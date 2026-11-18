/// Tabel `departemen`.
class DepartemenModel {
  final int _id;
  final int _idPerusahaan;
  String _namaDepartemen;
  double _anggaranTahunan;

  DepartemenModel({
    required int id,
    required int idPerusahaan,
    required String namaDepartemen,
    required double anggaranTahunan,
  })  : _id = id,
        _idPerusahaan = idPerusahaan,
        _namaDepartemen = namaDepartemen,
        _anggaranTahunan = anggaranTahunan;

  int get id => _id;
  int get idPerusahaan => _idPerusahaan;
  String get namaDepartemen => _namaDepartemen;
  double get anggaranTahunan => _anggaranTahunan;

  set namaDepartemen(String val) {
    if (val.trim().isNotEmpty) _namaDepartemen = val.trim();
  }

  set anggaranTahunan(double val) {
    if (val >= 0) _anggaranTahunan = val;
  }

  factory DepartemenModel.fromJson(Map<String, dynamic> json) => DepartemenModel(
        id: json['id'],
        idPerusahaan: json['id_perusahaan'],
        namaDepartemen: json['nama_departemen'] ?? '',
        anggaranTahunan: double.tryParse(json['anggaran_tahunan'].toString()) ?? 0.0,
      );
}
