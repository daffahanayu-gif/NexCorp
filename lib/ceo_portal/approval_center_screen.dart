import 'package:flutter/material.dart';

import '../models/pengajuan_model.dart';
import '../services/ceo_repository.dart';
import '../utils/format.dart';

/// CEO Approval Center: setujui atau tolak pengajuan yang berstatus Pending.
class ApprovalCenterScreen extends StatefulWidget {
  final CeoRepository repo;
  const ApprovalCenterScreen({super.key, required this.repo});

  @override
  State<ApprovalCenterScreen> createState() => _ApprovalCenterScreenState();
}

class _ApprovalCenterScreenState extends State<ApprovalCenterScreen> {
  List<PengajuanModel> _items = [];
  bool _loading = true;
  bool _error = false;
  final Set<int> _sibuk = {};

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final data = await widget.repo.getPengajuan();
      if (!mounted) return;
      setState(() {
        _items = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  Future<void> _putuskan(PengajuanModel p, String status) async {
    setState(() => _sibuk.add(p.id));
    try {
      final baru = await widget.repo.putKeputusan(p.id, status);
      if (!mounted) return;
      setState(() {
        final i = _items.indexWhere((x) => x.id == p.id);
        if (i != -1) _items[i] = baru;
        _sibuk.remove(p.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${p.jenisPengajuan} ${status == 'Approved' ? 'disetujui' : 'ditolak'}')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _sibuk.remove(p.id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keputusan belum tersimpan. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending = _items.where((p) => p.isPending).toList();
    final selesai = _items.where((p) => !p.isPending).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Approval')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Pengajuan belum bisa dimuat.'),
                      const SizedBox(height: 12),
                      FilledButton(onPressed: _muat, child: const Text('Coba lagi')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _muat,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text('Menunggu keputusan (${pending.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      if (pending.isEmpty) const Text('Tidak ada pengajuan yang menunggu.'),
                      for (final p in pending) _kartu(p),
                      if (selesai.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text('Sudah diputuskan', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        for (final p in selesai) _kartu(p),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _kartu(PengajuanModel p) {
    final tema = Theme.of(context);
    final sibuk = _sibuk.contains(p.id);
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${p.jenisPengajuan} • ${p.namaPt}', style: tema.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            Text(p.namaProyek, style: tema.textTheme.bodySmall),
            if (p.namaPemohon.isNotEmpty)
              Text('Diajukan oleh ${p.namaPemohon}', style: tema.textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(p.nominal > 0 ? formatRupiah(p.nominal) : 'Tanpa nominal', style: tema.textTheme.titleMedium),
            if (p.catatan.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(p.catatan, style: tema.textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            if (p.isPending)
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.green.shade700),
                      onPressed: sibuk ? null : () => _putuskan(p, 'Approved'),
                      child: const Text('Approve'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
                      onPressed: sibuk ? null : () => _putuskan(p, 'Rejected'),
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              )
            else
              Text(
                p.statusApproval == 'Approved' ? 'Disetujui' : 'Ditolak',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: p.statusApproval == 'Approved' ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
