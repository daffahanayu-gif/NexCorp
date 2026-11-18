/// Tabel `perusahaan` + data hasil JOIN/agregasi untuk dashboard CEO
/// (nama_sektor, rata_progres, laba_bersih).
class PerusahaanModel {
  final int _id;
  int _idSektor;
  String _namaSektor;
  String _kodePt;
  String _namaPt;
  String _kotaPusat;
  String _statusOperasional;
  double _rataProgres;
  double _labaBersih;

  PerusahaanModel({
    required int id,
    required int idSektor,
    String namaSektor = 'Umum',
    required String kodePt,
    required String namaPt,
    required String kotaPusat,
    String statusOperasional = 'Aktif',
    double rataProgres = 0,
    double labaBersih = 0,
  })  : _id = id,
        _idSektor = idSektor,
        _namaSektor = namaSektor,
        _kodePt = kodePt,
        _namaPt = namaPt,
        _kotaPusat = kotaPusat,
        _statusOperasional = statusOperasional,
        _rataProgres = rataProgres,
        _labaBersih = labaBersih;

  int get id => _id;
  int get idSektor => _idSektor;
  String get namaSektor => _namaSektor;
  String get kodePt => _kodePt;
  String get namaPt => _namaPt;
  String get kotaPusat => _kotaPusat;
  String get statusOperasional => _statusOperasional;
  double get rataProgres => _rataProgres;
  double get labaBersih => _labaBersih;

  set rataProgres(double val) {
    if (val >= 0 && val <= 100) _rataProgres = val;
  }

  set labaBersih(double val) => _labaBersih = val; // bisa negatif (rugi)

  set statusOperasional(String val) {
    if (val == 'Aktif' || val == 'Restrukturisasi') _statusOperasional = val;
  }

  set kotaPusat(String val) {
    if (val.trim().isNotEmpty) _kotaPusat = val.trim();
  }

  bool get isRestrukturisasi => _statusOperasional == 'Restrukturisasi';

  factory PerusahaanModel.fromJson(Map<String, dynamic> json) {
    return PerusahaanModel(
      id: json['id'],
      idSektor: json['id_sektor'] ?? 0,
      namaSektor: json['nama_sektor'] ?? 'Umum',
      kodePt: json['kode_pt'] ?? '',
      namaPt: json['nama_pt'] ?? '',
      kotaPusat: json['kota_pusat'] ?? '-',
      statusOperasional: json['status_operasional'] ?? 'Aktif',
      rataProgres: double.tryParse(json['rata_progres'].toString()) ?? 0.0,
      labaBersih: double.tryParse(json['laba_bersih'].toString()) ?? 0.0,
    );
  }
}
