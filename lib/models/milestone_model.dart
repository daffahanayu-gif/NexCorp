/// Tabel `milestone_proyek`.
class MilestoneModel {
  final int _id;
  final int _idProyek;
  String _namaTahapan;
  int _bobotPersen;
  bool _isSelesai;

  MilestoneModel({
    required int id,
    required int idProyek,
    required String namaTahapan,
    required int bobotPersen,
    bool isSelesai = false,
  })  : _id = id,
        _idProyek = idProyek,
        _namaTahapan = namaTahapan,
        _bobotPersen = bobotPersen,
        _isSelesai = isSelesai;

  int get id => _id;
  int get idProyek => _idProyek;
  String get namaTahapan => _namaTahapan;
  int get bobotPersen => _bobotPersen;
  bool get isSelesai => _isSelesai;

  set bobotPersen(int val) {
    if (val >= 1 && val <= 100) _bobotPersen = val;
  }

  set isSelesai(bool val) => _isSelesai = val;

  /// Progres proyek = jumlah bobot milestone yang sudah selesai (maks 100).
  static int hitungProgres(List<MilestoneModel> daftar) {
    final total = daftar
        .where((m) => m.isSelesai)
        .fold<int>(0, (a, m) => a + m.bobotPersen);
    return total > 100 ? 100 : total;
  }

  factory MilestoneModel.fromJson(Map<String, dynamic> json) => MilestoneModel(
        id: json['id'],
        idProyek: json['id_proyek'],
        namaTahapan: json['nama_tahapan'] ?? '',
        bobotPersen: int.tryParse(json['bobot_persen'].toString()) ?? 1,
        isSelesai: json['is_selesai'] == true,
      );
}
