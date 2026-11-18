/// Tabel `aset_perusahaan`.
class AsetModel {
  final int _id;
  final int _idPerusahaan;
  String _namaAset;
  String _kategoriAset;
  double _nilaiValuasi;
  String _kondisi; // 'Baik' | 'Perlu Perawatan'

  AsetModel({
    required int id,
    required int idPerusahaan,
    required String namaAset,
    required String kategoriAset,
    required double nilaiValuasi,
    String kondisi = 'Baik',
  })  : _id = id,
        _idPerusahaan = idPerusahaan,
        _namaAset = namaAset,
        _kategoriAset = kategoriAset,
        _nilaiValuasi = nilaiValuasi,
        _kondisi = kondisi;

  int get id => _id;
  int get idPerusahaan => _idPerusahaan;
  String get namaAset => _namaAset;
  String get kategoriAset => _kategoriAset;
  double get nilaiValuasi => _nilaiValuasi;
  String get kondisi => _kondisi;
  bool get perluPerawatan => _kondisi == 'Perlu Perawatan';

  set nilaiValuasi(double val) {
    if (val >= 0) _nilaiValuasi = val;
  }

  set kondisi(String val) {
    if (val == 'Baik' || val == 'Perlu Perawatan') _kondisi = val;
  }

  factory AsetModel.fromJson(Map<String, dynamic> json) => AsetModel(
        id: json['id'],
        idPerusahaan: json['id_perusahaan'],
        namaAset: json['nama_aset'] ?? '',
        kategoriAset: json['kategori_aset'] ?? '-',
        nilaiValuasi: double.tryParse(json['nilai_valuasi'].toString()) ?? 0.0,
        kondisi: json['kondisi'] ?? 'Baik',
      );
}
