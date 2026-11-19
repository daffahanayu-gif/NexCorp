import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth/sesi_pengguna.dart';
import '../models/proyek_model.dart';
import '../services/api_client.dart';
import '../services/manager_repository.dart';

/// Form Pengajuan Approval (POST /api/approval) -> tampil Pending di Approval CEO.
class FormPengajuanApprovalScreen extends StatefulWidget {
  final ProyekModel proyek;
  final SesiPengguna sesi;
  final ManagerRepository repo;
  const FormPengajuanApprovalScreen({super.key, required this.proyek, required this.sesi, required this.repo});

  @override
  State<FormPengajuanApprovalScreen> createState() => _FormPengajuanApprovalScreenState();
}

class _FormPengajuanApprovalScreenState extends State<FormPengajuanApprovalScreen> {
  static const _jenis = ['Tambahan Anggaran', 'Pengadaan Alat', 'Dana Ekspansi', 'Perpanjangan Target', 'Lainnya'];

  final _formKey = GlobalKey<FormState>();
  final _nominalC = TextEditingController();
  final _catatanC = TextEditingController();
  String _jenisDipilih = _jenis.first;
  bool _kirim = false;

  @override
  void dispose() {
    _nominalC.dispose();
    _catatanC.dispose();
    super.dispose();
  }

  bool get _nominalBolehNol => _jenisDipilih == 'Perpanjangan Target';

  Future<void> _ajukan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _kirim = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await widget.repo.ajukanApproval(
        idProyek: widget.proyek.id,
        idPemohon: widget.sesi.id,
        jenisPengajuan: _jenisDipilih,
        nominal: double.tryParse(_nominalC.text) ?? 0,
        catatan: _catatanC.text.trim(),
      );
      messenger.showSnackBar(const SnackBar(content: Text('Pengajuan terkirim, menunggu keputusan CEO')));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text(e is ApiException ? e.message : 'Pengajuan belum terkirim. Coba lagi.'),
        backgroundColor: Colors.red.shade700,
      ));
    } finally {
      if (mounted) setState(() => _kirim = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengajuan Approval')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Card(
                  elevation: 0,
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.work_outline),
                    title: Text(widget.proyek.namaProyek),
                    subtitle: const Text('Proyek yang diajukan'),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _jenisDipilih,
                  decoration: const InputDecoration(labelText: 'Jenis pengajuan', border: OutlineInputBorder()),
                  items: _jenis.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _jenisDipilih = v ?? _jenisDipilih),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nominalC,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Nominal (Rp)',
                    helperText: _nominalBolehNol ? 'Isi 0 bila tidak ada dana' : null,
                    prefixText: 'Rp ',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final n = double.tryParse(v ?? '');
                    if (n == null) return 'Nominal wajib diisi';
                    if (n <= 0 && !_nominalBolehNol) return 'Nominal harus lebih dari 0';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _catatanC,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Catatan / alasan',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().length < 10) ? 'Jelaskan alasan minimal 10 karakter' : null,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _kirim ? null : _ajukan,
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  icon: _kirim
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.send),
                  label: const Text('Kirim ke CEO'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
