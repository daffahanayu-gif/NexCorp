import 'package:flutter/material.dart';

import '../models/perusahaan_model.dart';
import '../services/ceo_repository.dart';
import '../utils/format.dart';
import 'company_detail_screen.dart';

class CeoDashboardScreen extends StatefulWidget {
  final CeoRepository repo;
  const CeoDashboardScreen({super.key, required this.repo});

  @override
  State<CeoDashboardScreen> createState() => _CeoDashboardScreenState();
}

class _CeoDashboardScreenState extends State<CeoDashboardScreen> {
  late Future<List<PerusahaanModel>> _future;
  String _sektor = 'Semua';

  @override
  void initState() {
    super.initState();
    _future = widget.repo.getRingkasan();
  }

  Future<void> _muatUlang() async {
    final f = widget.repo.getRingkasan();
    setState(() => _future = f);
    await f;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Holding')),
      body: FutureBuilder<List<PerusahaanModel>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Data anak perusahaan belum bisa dimuat.'),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: _muatUlang, child: const Text('Coba lagi')),
                  ],
                ),
              ),
            );
          }
          final semua = snap.data!;
          final sektorList = ['Semua', ...{...semua.map((p) => p.namaSektor)}];
          final tampil = _sektor == 'Semua'
              ? semua
              : semua.where((p) => p.namaSektor == _sektor).toList();
          final rata = semua.isEmpty
              ? 0.0
              : semua.fold<double>(0, (a, p) => a + p.rataProgres) / semua.length;
          final totalLaba = semua.fold<double>(0, (a, p) => a + p.labaBersih);
          final restruk = semua.where((p) => p.isRestrukturisasi).length;

          return RefreshIndicator(
            onRefresh: _muatUlang,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    _KpiCard(
                      label: 'Laba bersih holding',
                      nilai: formatRupiah(totalLaba),
                      warna: totalLaba < 0 ? Colors.red.shade700 : null,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _KpiCard(label: 'Anak perusahaan', nilai: '${semua.length}'),
                    const SizedBox(width: 8),
                    _KpiCard(label: 'Rata-rata progres', nilai: '${rata.toStringAsFixed(0)}%'),
                    const SizedBox(width: 8),
                    _KpiCard(label: 'Restrukturisasi', nilai: '$restruk', warna: restruk > 0 ? Colors.orange.shade800 : null),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final s in sektorList)
                      ChoiceChip(
                        label: Text(s),
                        selected: _sektor == s,
                        onSelected: (_) => setState(() => _sektor = s),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final pt in tampil)
                  _CompanyCard(
                    pt: pt,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompanyDetailScreen(pt: pt, repo: widget.repo),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String nilai;
  final Color? warna;
  const _KpiCard({required this.label, required this.nilai, this.warna});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(nilai, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: warna)),
              ),
              const SizedBox(height: 2),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final PerusahaanModel pt;
  final VoidCallback onTap;
  const _CompanyCard({required this.pt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(pt.namaPt, style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  if (pt.isRestrukturisasi)
                    Chip(
                      label: const Text('Restrukturisasi'),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Colors.orange.shade50,
                    ),
                ],
              ),
              Text('${pt.namaSektor} • ${pt.kodePt} • ${pt.kotaPusat}', style: tema.textTheme.bodySmall),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: pt.rataProgres / 100,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${pt.rataProgres.toStringAsFixed(0)}%'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Laba bersih ${formatRupiahRingkas(pt.labaBersih)}',
                style: tema.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: pt.labaBersih < 0 ? Colors.red.shade700 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
