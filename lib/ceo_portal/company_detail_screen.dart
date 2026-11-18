import 'package:flutter/material.dart';

import '../models/perusahaan_model.dart';
import '../services/ceo_repository.dart';
import '../utils/format.dart';
import 'company_tabs.dart';

/// Menerima objek PerusahaanModel lewat Navigator.push.
class CompanyDetailScreen extends StatelessWidget {
  final PerusahaanModel pt;
  final CeoRepository repo;
  const CompanyDetailScreen({super.key, required this.pt, required this.repo});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(pt.namaPt),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Proyek'),
              Tab(text: 'Keuangan'),
              Tab(text: 'Aset'),
              Tab(text: 'Departemen'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${pt.namaSektor} • ${pt.kodePt} • ${pt.kotaPusat}', style: tema.textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text('Status ${pt.statusOperasional}', style: tema.textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    'Laba bersih ${formatRupiah(pt.labaBersih)}',
                    style: tema.textTheme.titleSmall?.copyWith(
                      color: pt.labaBersih < 0 ? Colors.red.shade700 : null,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ProyekTab(repo: repo, idPerusahaan: pt.id),
                  KeuanganTab(repo: repo, idPerusahaan: pt.id),
                  AsetTab(repo: repo, idPerusahaan: pt.id),
                  DepartemenTab(repo: repo, idPerusahaan: pt.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
