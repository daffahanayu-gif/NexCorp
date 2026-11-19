import 'package:flutter/material.dart';

import '../models/proyek_model.dart';
import '../services/api_client.dart';
import '../services/manager_repository.dart';

/// Dialog Update Progres: Slider 0-100 + Dropdown status (PUT /api/proyek/:id).
/// Menutup dengan `true` bila berhasil.
class UpdateProgresDialog extends StatefulWidget {
  final ProyekModel proyek;
  final ManagerRepository repo;
  const UpdateProgresDialog({super.key, required this.proyek, required this.repo});

  @override
  State<UpdateProgresDialog> createState() => _UpdateProgresDialogState();
}

class _UpdateProgresDialogState extends State<UpdateProgresDialog> {
  late double _persen = widget.proyek.progresPersen.toDouble();
  late String _status = widget.proyek.statusProyek;
  bool _simpan = false;
  String? _error;

  Future<void> _kirim() async {
    setState(() {
      _simpan = true;
      _error = null;
    });
    try {
      await widget.repo.updateProgres(widget.proyek.id, _persen.round(), _status);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => _error = e is ApiException ? e.message : 'Progres belum tersimpan. Coba lagi.');
    } finally {
      if (mounted) setState(() => _simpan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update progres'),
      content: SizedBox(
        width: 380,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.proyek.namaProyek, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Center(child: Text('${_persen.round()}%', style: Theme.of(context).textTheme.headlineMedium)),
          Slider(
            value: _persen,
            min: 0,
            max: 100,
            divisions: 20,
            label: '${_persen.round()}%',
            onChanged: _simpan
                ? null
                : (v) => setState(() {
                      _persen = v;
                      // Status mengikuti progres, tetap bisa diubah manual (mis. Terhambat).
                      if (v >= 100) {
                        _status = 'Selesai';
                      } else if (_status == 'Selesai') {
                        _status = 'Berjalan';
                      }
                    }),
          ),
          DropdownButtonFormField<String>(
            key: ValueKey(_status),
            initialValue: _status,
            decoration: const InputDecoration(labelText: 'Status proyek', border: OutlineInputBorder()),
            items: ProyekModel.statusValid.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: _simpan ? null : (v) => setState(() => _status = v ?? _status),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: Colors.red.shade700)),
          ],
        ]),
      ),
      actions: [
        TextButton(onPressed: _simpan ? null : () => Navigator.pop(context, false), child: const Text('Batal')),
        FilledButton(
          onPressed: _simpan ? null : _kirim,
          child: _simpan
              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Simpan'),
        ),
      ],
    );
  }
}
