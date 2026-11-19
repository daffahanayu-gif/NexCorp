import 'package:flutter/material.dart';

import '../auth/sesi_pengguna.dart';
import '../models/proyek_model.dart';
import '../services/api_client.dart';
import '../services/manager_repository.dart';
import '../utils/format.dart';
import 'form_pengajuan_approval_screen.dart';
import 'form_tambah_proyek_screen.dart';
import 'update_progres_dialog.dart';

Color warnaStatusProyek(String s) {
  switch (s) {
    case 'Selesai':
      return Colors.green.shade700;
    case 'Terhambat':
      return Colors.red.shade700;
    case 'Perencanaan':
      return Colors.blueGrey;
    default:
      return Colors.blue.shade700;
  }
}

/// Tab Proyek Manajer: daftar proyek PT + tambah, update progres, ajukan, hapus.
class ManagerDashboardScreen extends StatefulWidget {
  final SesiPengguna sesi;
  final ManagerRepository repo;
  final VoidCallback onKeluar;
  const ManagerDashboardScreen({super.key, required this.sesi, required this.repo, required this.onKeluar});

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  late Future<List<ProyekModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _ambil();
  }

  Future<List<ProyekModel>> _ambil() {
    final idPt = widget.sesi.idPerusahaan;
    if (idPt == null) {
      return Future.error(ApiException('Akun ini belum terhubung ke anak perusahaan.'));
    }
    return widget.repo.getProyek(idPt);
  }

  Future<void> _muatUlang() async {
    final f = _ambil();
    setState(() => _future = f);
    try {
      await f;
    } catch (_) {}
  }

  void _snack(String pesan, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(pesan),
      backgroundColor: error ? Colors.red.shade700 : null,
    ));
  }

  Future<void> _tambah() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormTambahProyekScreen(idPerusahaan: widget.sesi.idPerusahaan!, repo: widget.repo),
      ),
    );
    if (ok == true && mounted) {
      _snack('Proyek berhasil ditambahkan');
      _muatUlang();
    }
  }

  Future<void> _updateProgres(ProyekModel p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => UpdateProgresDialog(proyek: p, repo: widget.repo),
    );
    if (ok == true && mounted) {
      _snack('Progres "${p.namaProyek}" diperbarui');
      _muatUlang();
    }
  }

  Future<void> _ajukan(ProyekModel p) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormPengajuanApprovalScreen(proyek: p, sesi: widget.sesi, repo: widget.repo),
      ),
    );
  }

  /// DELETE /api/proyek/:id dengan dialog konfirmasi.
  Future<void> _hapus(ProyekModel p) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 36),
        title: const Text('Hapus proyek?'),
        content: Text('Proyek "${p.namaProyek}" akan dihapus permanen beserta pengajuan '
            'approval terkait. Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yakin != true) return;
    try {
      await widget.repo.hapusProyek(p.id);
      if (!mounted) return;
      _snack('Proyek dihapus');
      _muatUlang();
    } on ApiException catch (e) {
      if (mounted) _snack(e.message, error: true);
    } catch (_) {
      if (mounted) _snack('Proyek belum terhapus. Coba lagi.', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyek Saya'),
        actions: [
          IconButton(tooltip: 'Muat ulang', icon: const Icon(Icons.refresh), onPressed: _muatUlang),
          IconButton(tooltip: 'Keluar', icon: const Icon(Icons.logout), onPressed: widget.onKeluar),
        ],
      ),
      floatingActionButton: widget.sesi.idPerusahaan == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _tambah,
              icon: const Icon(Icons.add),
              label: const Text('Proyek baru'),
            ),
      body: FutureBuilder<List<ProyekModel>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('${snap.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _muatUlang, child: const Text('Coba lagi')),
                ]),
              ),
            );
          }
          final data = snap.data ?? [];
          return RefreshIndicator(
            onRefresh: _muatUlang,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.business),
                    title: Text(widget.sesi.namaPt, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${widget.sesi.nama} · ${widget.sesi.namaDepartemen}'),
                  ),
                ),
                if (data.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('Belum ada proyek. Tekan "Proyek baru" untuk menambah.')),
                  ),
                for (final p in data) _kartuProyek(tema, p),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _kartuProyek(ThemeData tema, ProyekModel p) {
    final warna = warnaStatusProyek(p.statusProyek);
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(p.namaProyek, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            const SizedBox(width: 8),
            Text(p.statusProyek, style: TextStyle(color: warna, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 4),
          Text(
            'Target selesai: ${formatTanggal(p.targetSelesai)}${p.terlambat ? ' (terlambat)' : ''}',
            style: tema.textTheme.bodySmall?.copyWith(color: p.terlambat ? Colors.red.shade700 : null),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(value: p.progresPersen / 100, minHeight: 10, color: warna),
              ),
            ),
            const SizedBox(width: 10),
            Text('${p.progresPersen}%', style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 4, children: [
            TextButton.icon(
              onPressed: () => _updateProgres(p),
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('Update progres'),
            ),
            TextButton.icon(
              onPressed: () => _ajukan(p),
              icon: const Icon(Icons.request_quote_outlined, size: 18),
              label: const Text('Ajukan approval'),
            ),
            TextButton.icon(
              onPressed: () => _hapus(p),
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Hapus'),
            ),
          ]),
        ]),
      ),
    );
  }
}
