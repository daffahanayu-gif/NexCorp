import 'package:flutter/material.dart';

import '../models/proyek_model.dart';
import '../services/api_client.dart';
import '../services/manager_repository.dart';
import '../utils/format.dart';

/// Form Tambah Proyek Strategis Baru (POST /api/proyek). Pop `true` bila sukses.
class FormTambahProyekScreen extends StatefulWidget {
  final int idPerusahaan;
  final ManagerRepository repo;
  const FormTambahProyekScreen({super.key, required this.idPerusahaan, required this.repo});

  @override
  State<FormTambahProyekScreen> createState() => _FormTambahProyekScreenState();
}

class _FormTambahProyekScreenState extends State<FormTambahProyekScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaC = TextEditingController();
  DateTime? _target;
  String _status = 'Perencanaan';
  bool _simpan = false;

  @override
  void dispose() {
    _namaC.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _target ?? now.add(const Duration(days: 30)),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 10),
    );
    if (d != null) setState(() => _target = d);
  }

  Future<void> _kirim() async {
    if (!_formKey.currentState!.validate()) return;
    if (_target == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih target selesai terlebih dahulu')));
      return;
    }
    setState(() => _simpan = true);
    try {
      await widget.repo.tambahProyek(
        idPerusahaan: widget.idPerusahaan,
        namaProyek: _namaC.text.trim(),
        targetSelesai: _target!,
        statusProyek: _status,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e is ApiException ? e.message : 'Proyek belum tersimpan. Coba lagi.'),
        backgroundColor: Colors.red.shade700,
      ));
    } finally {
      if (mounted) setState(() => _simpan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Proyek Strategis')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                TextFormField(
                  controller: _namaC,
                  maxLength: 120,
                  decoration: const InputDecoration(
                    labelText: 'Nama proyek',
                    prefixIcon: Icon(Icons.work_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return 'Nama proyek wajib diisi';
                    if (s.length < 5) return 'Minimal 5 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pilihTanggal,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Target selesai',
                      prefixIcon: Icon(Icons.event),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(_target == null ? 'Pilih tanggal' : formatTanggal(_target!)),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Status awal', border: OutlineInputBorder()),
                  items: ProyekModel.statusValid
                      .where((s) => s == 'Perencanaan' || s == 'Berjalan')
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _status = v ?? _status),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _simpan ? null : _kirim,
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  icon: _simpan
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: const Text('Simpan proyek'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
