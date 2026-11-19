import '../data/dummy_store.dart';
import '../models/pengajuan_model.dart';
import '../models/proyek_model.dart';
import 'api_client.dart';

/// Kontrak data Portal Manajer (Dev 4).
abstract class ManagerRepository {
  Future<List<ProyekModel>> getProyek(int idPerusahaan); // GET /api/proyek?id_perusahaan=
  Future<ProyekModel> tambahProyek({
    required int idPerusahaan,
    required String namaProyek,
    required DateTime targetSelesai,
    required String statusProyek,
  }); // POST /api/proyek
  Future<ProyekModel> updateProgres(int idProyek, int persen, String status); // PUT /api/proyek/:id
  Future<void> hapusProyek(int idProyek); // DELETE /api/proyek/:id
  Future<PengajuanModel> ajukanApproval({
    required int idProyek,
    required int idPemohon,
    required String jenisPengajuan,
    required double nominal,
    required String catatan,
  }); // POST /api/approval
  Future<List<PengajuanModel>> getPengajuanSaya(int idPemohon); // GET /api/approval?id_pemohon=
}

/// Implementasi dummy (mode demo tanpa backend).
class DummyManagerRepository implements ManagerRepository {
  final _s = DummyStore.instance;

  Future<void> _tunda() => Future.delayed(const Duration(milliseconds: 400));

  @override
  Future<List<ProyekModel>> getProyek(int idPerusahaan) async {
    await _tunda();
    return _s.proyek.where((p) => p.idPerusahaan == idPerusahaan).toList();
  }

  @override
  Future<ProyekModel> tambahProyek({
    required int idPerusahaan,
    required String namaProyek,
    required DateTime targetSelesai,
    required String statusProyek,
  }) async {
    await _tunda();
    final baru = ProyekModel(
      id: _s.idProyekBerikutnya(),
      idPerusahaan: idPerusahaan,
      namaProyek: namaProyek,
      targetSelesai: targetSelesai,
      progresPersen: 0,
      statusProyek: statusProyek,
    );
    _s.proyek.add(baru);
    return baru;
  }

  @override
  Future<ProyekModel> updateProgres(int idProyek, int persen, String status) async {
    await _tunda();
    final p = _s.proyek.firstWhere((x) => x.id == idProyek);
    p.progresPersen = persen;
    p.statusProyek = status;
    return p;
  }

  @override
  Future<void> hapusProyek(int idProyek) async {
    await _tunda();
    _s.proyek.removeWhere((p) => p.id == idProyek);
    // ON DELETE CASCADE seperti di database
    _s.pengajuan.removeWhere((a) => a.idProyek == idProyek);
  }

  @override
  Future<PengajuanModel> ajukanApproval({
    required int idProyek,
    required int idPemohon,
    required String jenisPengajuan,
    required double nominal,
    required String catatan,
  }) async {
    await _tunda();
    final proyek = _s.proyek.firstWhere((p) => p.id == idProyek);
    final pt = _s.perusahaan.firstWhere((p) => p.id == proyek.idPerusahaan);
    final pemohon = _s.pengguna.firstWhere((u) => u.id == idPemohon);
    final baru = PengajuanModel(
      id: _s.idPengajuanBerikutnya(),
      idProyek: idProyek,
      idPemohon: idPemohon,
      namaProyek: proyek.namaProyek,
      namaPt: pt.namaPt,
      namaPemohon: pemohon.nama,
      jenisPengajuan: jenisPengajuan,
      nominal: nominal,
      catatan: catatan,
    );
    _s.pengajuan.add(baru);
    return baru;
  }

  /// Khusus demo: meniru keputusan CEO karena aplikasi ini berdiri sendiri.
  Future<void> simulasiKeputusanCeo(int idPengajuan, String status) async {
    await _tunda();
    _s.pengajuan.firstWhere((a) => a.id == idPengajuan).statusApproval = status;
  }

  @override
  Future<List<PengajuanModel>> getPengajuanSaya(int idPemohon) async {
    await _tunda();
    return _s.pengajuan.where((a) => a.idPemohon == idPemohon).toList().reversed.toList();
  }
}

/// Implementasi API (aktif dengan --dart-define=USE_API=true). Kontrak endpoint
/// yang diasumsikan ada di DEV4_README.md dan perlu disamakan dengan Dev 2.
class ApiManagerRepository implements ManagerRepository {
  static List<T> _daftar<T>(dynamic data, T Function(Map<String, dynamic>) dari) =>
      data is List ? data.whereType<Map<String, dynamic>>().map(dari).toList() : <T>[];

  static Map<String, dynamic> _baris(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    throw ApiException('Respons server tidak valid.');
  }

  static String _tanggal(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Future<List<ProyekModel>> getProyek(int idPerusahaan) async {
    final data = await ApiClient.request('GET', '/proyek',
        query: {'id_perusahaan': '$idPerusahaan'}, gagal: 'Gagal memuat proyek');
    return _daftar(data, ProyekModel.fromJson).where((p) => p.idPerusahaan == idPerusahaan).toList();
  }

  @override
  Future<ProyekModel> tambahProyek({
    required int idPerusahaan,
    required String namaProyek,
    required DateTime targetSelesai,
    required String statusProyek,
  }) async {
    final data = await ApiClient.request('POST', '/proyek',
        body: {
          'id_perusahaan': idPerusahaan,
          'nama_proyek': namaProyek,
          'target_selesai': _tanggal(targetSelesai),
          'progres_persen': 0,
          'status_proyek': statusProyek,
        },
        gagal: 'Gagal menambah proyek');
    return ProyekModel.fromJson(_baris(data));
  }

  @override
  Future<ProyekModel> updateProgres(int idProyek, int persen, String status) async {
    final data = await ApiClient.request('PUT', '/proyek/$idProyek',
        body: {'progres_persen': persen, 'status_proyek': status}, gagal: 'Gagal memperbarui progres');
    return ProyekModel.fromJson(_baris(data));
  }

  @override
  Future<void> hapusProyek(int idProyek) =>
      ApiClient.request('DELETE', '/proyek/$idProyek', gagal: 'Gagal menghapus proyek');

  @override
  Future<PengajuanModel> ajukanApproval({
    required int idProyek,
    required int idPemohon,
    required String jenisPengajuan,
    required double nominal,
    required String catatan,
  }) async {
    final data = await ApiClient.request('POST', '/approval',
        body: {
          'id_proyek': idProyek,
          'id_pemohon': idPemohon,
          'jenis_pengajuan': jenisPengajuan,
          'nominal': nominal,
          'catatan': catatan,
          'status_approval': 'Pending',
        },
        gagal: 'Gagal mengirim pengajuan');
    return PengajuanModel.fromJson(_baris(data));
  }

  @override
  Future<List<PengajuanModel>> getPengajuanSaya(int idPemohon) async {
    final data = await ApiClient.request('GET', '/approval',
        query: {'id_pemohon': '$idPemohon'}, gagal: 'Gagal memuat pengajuan');
    return _daftar(data, PengajuanModel.fromJson).where((a) => a.idPemohon == idPemohon).toList();
  }
}
