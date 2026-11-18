import 'package:flutter/material.dart';

import '../models/aset_model.dart';
import '../models/departemen_model.dart';
import '../models/laporan_keuangan_model.dart';
import '../models/milestone_model.dart';
import '../models/proyek_model.dart';
import '../services/ceo_repository.dart';
import '../utils/format.dart';
import 'widgets/muat_data.dart';

Color _warnaStatusProyek(String s) {
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

const _paddingList = EdgeInsets.all(16);

// ---------------------------------------------------------------- Proyek

class ProyekTab extends StatelessWidget {
  final CeoRepository repo;
  final int idPerusahaan;
  const ProyekTab({super.key, required this.repo, required this.idPerusahaan});

  @override
  Widget build(BuildContext context) {
    return MuatData<ProyekModel>(
      ambil: () => repo.getProyekByPerusahaan(idPerusahaan),
      kosong: 'Belum ada proyek untuk perusahaan ini.',
      builder: (context, daftar) => ListView(
        padding: _paddingList,
        children: [for (final p in daftar) _ProyekCard(proyek: p, repo: repo)],
      ),
    );
  }
}

class _ProyekCard extends StatelessWidget {
  final ProyekModel proyek;
  final CeoRepository repo;
  const _ProyekCard({required this.proyek, required this.repo});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = _warnaStatusProyek(proyek.statusProyek);
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        title: Row(
          children: [
            Expanded(child: Text(proyek.namaProyek, style: tema.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600))),
            Text(proyek.statusProyek, style: TextStyle(color: warna, fontWeight: FontWeight.w600)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Target ${formatTanggal(proyek.targetSelesai)}${proyek.terlambat ? ' (lewat target)' : ''}',
                style: tema.textTheme.bodySmall?.copyWith(color: proyek.terlambat ? Colors.red.shade700 : null),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: proyek.progresPersen / 100,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                      color: warna,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${proyek.progresPersen}%'),
                ],
              ),
            ],
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        children: [
          MuatData<MilestoneModel>(
            ambil: () => repo.getMilestone(proyek.id),
            kosong: 'Belum ada milestone untuk proyek ini.',
            builder: (context, daftar) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final m in daftar)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          m.isSelesai ? Icons.check_circle : Icons.radio_button_unchecked,
                          size: 20,
                          color: m.isSelesai ? Colors.green.shade700 : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(m.namaTahapan)),
                        Text('${m.bobotPersen}%', style: tema.textTheme.bodySmall),
                      ],
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  'Progres dari milestone: ${MilestoneModel.hitungProgres(daftar)}%',
                  style: tema.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------- Keuangan

class KeuanganTab extends StatelessWidget {
  final CeoRepository repo;
  final int idPerusahaan;
  const KeuanganTab({super.key, required this.repo, required this.idPerusahaan});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return MuatData<LaporanKeuanganModel>(
      ambil: () => repo.getLaporan(idPerusahaan),
      kosong: 'Belum ada laporan keuangan.',
      builder: (context, data) {
        final daftar = [...data]..sort((a, b) => b.bulanTahun.compareTo(a.bulanTahun));
        return ListView(
          padding: _paddingList,
          children: [
            for (final l in daftar)
              Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  shape: const Border(),
                  collapsedShape: const Border(),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  title: Row(
                    children: [
                      Expanded(child: Text(formatBulanTahun(l.bulanTahun), style: tema.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600))),
                      Chip(
                        label: Text(l.statusAudit),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: l.isVerified ? Colors.green.shade50 : Colors.grey.shade200,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Laba bersih ${formatRupiah(l.labaBersih)}',
                    style: TextStyle(color: l.labaBersih < 0 ? Colors.red.shade700 : null),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                  children: [
                    _baris('Total pemasukan', formatRupiah(l.totalPemasukan), tema),
                    _baris('Total pengeluaran', formatRupiah(l.totalPengeluaran), tema),
                    const Divider(),
                    for (final t in l.transaksi)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.keterangan),
                                  Text(formatTanggal(t.tanggalTransaksi), style: tema.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            Text(
                              '${t.isPemasukan ? '+' : '-'} ${formatRupiahRingkas(t.nominal)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: t.isPemasukan ? Colors.green.shade700 : Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _baris(String label, String nilai, ThemeData tema) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(nilai, style: tema.textTheme.titleSmall)],
        ),
      );
}

// ------------------------------------------------------------------ Aset

class AsetTab extends StatelessWidget {
  final CeoRepository repo;
  final int idPerusahaan;
  const AsetTab({super.key, required this.repo, required this.idPerusahaan});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return MuatData<AsetModel>(
      ambil: () => repo.getAset(idPerusahaan),
      kosong: 'Belum ada aset tercatat.',
      builder: (context, daftar) {
        final total = daftar.fold<double>(0, (a, s) => a + s.nilaiValuasi);
        return ListView(
          padding: _paddingList,
          children: [
            Text('Total valuasi ${formatRupiahRingkas(total)}', style: tema.textTheme.titleMedium),
            const SizedBox(height: 10),
            for (final a in daftar)
              Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(a.namaAset),
                  subtitle: Text('${a.kategoriAset} • ${formatRupiahRingkas(a.nilaiValuasi)}'),
                  trailing: Chip(
                    label: Text(a.kondisi),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: a.perluPerawatan ? Colors.orange.shade50 : Colors.green.shade50,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ----------------------------------------------------------- Departemen

class DepartemenTab extends StatelessWidget {
  final CeoRepository repo;
  final int idPerusahaan;
  const DepartemenTab({super.key, required this.repo, required this.idPerusahaan});

  @override
  Widget build(BuildContext context) {
    return MuatData<DepartemenModel>(
      ambil: () => repo.getDepartemen(idPerusahaan),
      kosong: 'Belum ada departemen.',
      builder: (context, daftar) => ListView(
        padding: _paddingList,
        children: [
          for (final d in daftar)
            Card(
              elevation: 0,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(d.namaDepartemen),
                subtitle: Text('Anggaran tahunan ${formatRupiahRingkas(d.anggaranTahunan)}'),
              ),
            ),
        ],
      ),
    );
  }
}
