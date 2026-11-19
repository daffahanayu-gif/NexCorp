import 'package:flutter/material.dart';

import '../auth/sesi_pengguna.dart';
import '../models/pengajuan_model.dart';
import '../services/manager_repository.dart';
import '../utils/format.dart';
import '../widgets/muat_data.dart';

/// Tab Pengajuan Manajer: riwayat pengajuan sendiri + keputusan CEO.
class PengajuanSayaScreen extends StatefulWidget {
  final SesiPengguna sesi;
  final ManagerRepository repo;
  final VoidCallback onKeluar;
  const PengajuanSayaScreen({super.key, required this.sesi, required this.repo, required this.onKeluar});

  @override
  State<PengajuanSayaScreen> createState() => _PengajuanSayaScreenState();
}

class _PengajuanSayaScreenState extends State<PengajuanSayaScreen> {
  int _versi = 0;

  /// Khusus mode demo: aplikasi ini berdiri sendiri, jadi keputusan CEO disimulasikan.
  Future<void> _simulasi(int id, String status) async {
    await (widget.repo as DummyManagerRepository).simulasiKeputusanCeo(id, status);
    if (mounted) setState(() => _versi++);
  }

  Color _warna(String s) => s == 'Approved'
      ? Colors.green.shade700
      : s == 'Rejected'
          ? Colors.red.shade700
          : Colors.orange.shade800;

  String _label(String s) => s == 'Approved'
      ? 'Disetujui'
      : s == 'Rejected'
          ? 'Ditolak'
          : 'Menunggu CEO';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Saya'),
        actions: [IconButton(tooltip: 'Keluar', icon: const Icon(Icons.logout), onPressed: widget.onKeluar)],
      ),
      body: MuatData<PengajuanModel>(
        key: ValueKey(_versi),
        ambil: () => widget.repo.getPengajuanSaya(widget.sesi.id),
        kosong: 'Belum ada pengajuan. Ajukan dari tab Proyek.',
        builder: (context, data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final a in data)
              Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(a.jenisPengajuan, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                      Text(_label(a.statusApproval), style: TextStyle(color: _warna(a.statusApproval), fontWeight: FontWeight.w600)),
                      if (widget.repo is DummyManagerRepository && a.isPending)
                        PopupMenuButton<String>(
                          tooltip: 'Simulasi keputusan CEO (demo)',
                          icon: const Icon(Icons.science_outlined, size: 20),
                          onSelected: (st) => _simulasi(a.id, st),
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'Approved', child: Text('Simulasi: CEO setujui')),
                            PopupMenuItem(value: 'Rejected', child: Text('Simulasi: CEO tolak')),
                          ],
                        ),
                    ]),
                    const SizedBox(height: 4),
                    Text(a.namaProyek, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(formatRupiah(a.nominal), style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (a.catatan.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(a.catatan),
                    ],
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
