/// Tabel `proyek_operasional`.
class ProyekModel {
  final int _id;
  final int _idPerusahaan;
  String _namaProyek;
  DateTime _targetSelesai;
  int _progresPersen;
  String _statusProyek;

  static const List<String> statusValid = [
    'Perencanaan',
    'Berjalan',
    'Selesai',
    'Terhambat',
  ];

  ProyekModel({
    required int id,
    required int idPerusahaan,
    required String namaProyek,
    required DateTime targetSelesai,
    int progresPersen = 0,
    String statusProyek = 'Berjalan',
  })  : _id = id,
        _idPerusahaan = idPerusahaan,
        _namaProyek = namaProyek,
        _targetSelesai = targetSelesai,
        _progresPersen = progresPersen,
        _statusProyek = statusProyek;

  int get id => _id;
  int get idPerusahaan => _idPerusahaan;
  String get namaProyek => _namaProyek;
  DateTime get targetSelesai => _targetSelesai;
  int get progresPersen => _progresPersen;
  String get statusProyek => _statusProyek;

  set progresPersen(int val) {
    if (val >= 0 && val <= 100) _progresPersen = val;
  }

  set statusProyek(String val) {
    if (statusValid.contains(val)) _statusProyek = val;
  }

  set namaProyek(String val) {
    if (val.trim().isNotEmpty) _namaProyek = val.trim();
  }

  set targetSelesai(DateTime val) => _targetSelesai = val;

  /// Proyek lewat target tapi belum selesai.
  bool get terlambat =>
      _statusProyek != 'Selesai' && _targetSelesai.isBefore(DateTime.now());

  factory ProyekModel.fromJson(Map<String, dynamic> json) {
    return ProyekModel(
      id: json['id'],
      idPerusahaan: json['id_perusahaan'],
      namaProyek: json['nama_proyek'] ?? '',
      targetSelesai: DateTime.tryParse(json['target_selesai'].toString()) ??
          DateTime.now(),
      progresPersen: int.tryParse(json['progres_persen'].toString()) ?? 0,
      statusProyek: json['status_proyek'] ?? 'Berjalan',
    );
  }
}
