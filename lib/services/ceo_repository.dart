import '../data/dummy_data.dart';
import '../models/aset_model.dart';
import '../models/departemen_model.dart';
import '../models/laporan_keuangan_model.dart';
import '../models/milestone_model.dart';
import '../models/pengajuan_model.dart';
import '../models/perusahaan_model.dart';
import '../models/proyek_model.dart';

/// Kontrak data Portal CEO. Layar hanya bergantung pada kelas ini; saat API
/// Dev 2 siap, buat `ApiCeoRepository` (package http) dan tukar di main.dart.
abstract class CeoRepository {
  Future<List<PerusahaanModel>> getRingkasan(); // GET /api/ceo/ringkasan
  Future<List<DepartemenModel>> getDepartemen(int idPerusahaan);
  Future<List<ProyekModel>> getProyekByPerusahaan(int idPerusahaan);
  Future<List<MilestoneModel>> getMilestone(int idProyek);
  Future<List<LaporanKeuanganModel>> getLaporan(int idPerusahaan); // termasuk transaksi kas
  Future<List<AsetModel>> getAset(int idPerusahaan);
  Future<List<PengajuanModel>> getPengajuan();
  Future<PengajuanModel> putKeputusan(int id, String status); // PUT /api/approval/:id
}

/// Implementasi sementara: data dummy di memori.
class DummyCeoRepository implements CeoRepository {
  final _perusahaan = buatDummyPerusahaan();
  final _departemen = buatDummyDepartemen();
  final _proyek = buatDummyProyek();
  final _milestone = buatDummyMilestone();
  final _laporan = buatDummyLaporan();
  final _aset = buatDummyAset();
  final _pengajuan = buatDummyPengajuan();

  Future<void> _tunda() => Future.delayed(const Duration(milliseconds: 400));

  @override
  Future<List<PerusahaanModel>> getRingkasan() async {
    await _tunda();
    // Meniru query analitik Dev 1: rata-rata progres & laba bersih per PT.
    for (final pt in _perusahaan) {
      final milik = _proyek.where((p) => p.idPerusahaan == pt.id).toList();
      pt.rataProgres = milik.isEmpty
          ? 0
          : milik.fold<int>(0, (a, p) => a + p.progresPersen) / milik.length;
      pt.labaBersih = _laporan
          .where((l) => l.idPerusahaan == pt.id)
          .fold<double>(0, (a, l) => a + l.labaBersih);
    }
    return List.of(_perusahaan);
  }

  @override
  Future<List<DepartemenModel>> getDepartemen(int idPerusahaan) async {
    await _tunda();
    return _departemen.where((d) => d.idPerusahaan == idPerusahaan).toList();
  }

  @override
  Future<List<ProyekModel>> getProyekByPerusahaan(int idPerusahaan) async {
    await _tunda();
    return _proyek.where((p) => p.idPerusahaan == idPerusahaan).toList();
  }

  @override
  Future<List<MilestoneModel>> getMilestone(int idProyek) async {
    await _tunda();
    return _milestone.where((m) => m.idProyek == idProyek).toList();
  }

  @override
  Future<List<LaporanKeuanganModel>> getLaporan(int idPerusahaan) async {
    await _tunda();
    return _laporan.where((l) => l.idPerusahaan == idPerusahaan).toList();
  }

  @override
  Future<List<AsetModel>> getAset(int idPerusahaan) async {
    await _tunda();
    return _aset.where((a) => a.idPerusahaan == idPerusahaan).toList();
  }

  @override
  Future<List<PengajuanModel>> getPengajuan() async {
    await _tunda();
    return List.of(_pengajuan);
  }

  @override
  Future<PengajuanModel> putKeputusan(int id, String status) async {
    await _tunda();
    final item = _pengajuan.firstWhere((p) => p.id == id);
    item.statusApproval = status;
    return item;
  }
}
