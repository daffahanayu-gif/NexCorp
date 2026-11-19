import 'package:flutter/material.dart';

/// Pembungkus FutureBuilder berisi daftar: loading, error (+coba lagi), kosong.
class MuatData<T> extends StatefulWidget {
  final Future<List<T>> Function() ambil;
  final String kosong;
  final Widget Function(BuildContext context, List<T> data) builder;

  const MuatData({
    super.key,
    required this.ambil,
    required this.builder,
    this.kosong = 'Belum ada data.',
  });

  @override
  State<MuatData<T>> createState() => _MuatDataState<T>();
}

class _MuatDataState<T> extends State<MuatData<T>>
    with AutomaticKeepAliveClientMixin {
  late Future<List<T>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = widget.ambil();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<T>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Data belum bisa dimuat.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => setState(() => _future = widget.ambil()),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          );
        }
        final data = snap.data ?? [];
        if (data.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: Text(widget.kosong)),
          );
        }
        return widget.builder(context, data);
      },
    );
  }
}
