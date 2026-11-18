/// Tabel `sektor_industri`.
class SektorModel {
  final int _id;
  String _namaSektor;
  String? _deskripsiSektor;

  SektorModel({required int id, required String namaSektor, String? deskripsiSektor})
      : _id = id,
        _namaSektor = namaSektor,
        _deskripsiSektor = deskripsiSektor;

  int get id => _id;
  String get namaSektor => _namaSektor;
  String? get deskripsiSektor => _deskripsiSektor;

  set namaSektor(String val) {
    if (val.trim().isNotEmpty) _namaSektor = val.trim();
  }

  set deskripsiSektor(String? val) => _deskripsiSektor = val;

  factory SektorModel.fromJson(Map<String, dynamic> json) => SektorModel(
        id: json['id'],
        namaSektor: json['nama_sektor'] ?? '',
        deskripsiSektor: json['deskripsi_sektor'],
      );
}
