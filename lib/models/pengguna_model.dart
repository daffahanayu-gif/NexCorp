/// Tabel `pengguna`. Kolom password sengaja TIDAK dimodelkan di sisi aplikasi.
/// CEO memiliki idDepartemen == null.
class PenggunaModel {
  final int _id;
  final int? _idDepartemen;
  String _nama;
  String _email;
  final String _role;

  PenggunaModel({
    required int id,
    int? idDepartemen,
    required String nama,
    required String email,
    required String role,
  })  : _id = id,
        _idDepartemen = idDepartemen,
        _nama = nama,
        _email = email,
        _role = role;

  int get id => _id;
  int? get idDepartemen => _idDepartemen;
  String get nama => _nama;
  String get email => _email;
  String get role => _role;
  bool get isCeo => _role == 'CEO';

  set nama(String val) {
    if (val.trim().isNotEmpty) _nama = val.trim();
  }

  set email(String val) {
    if (val.contains('@')) _email = val.trim();
  }

  factory PenggunaModel.fromJson(Map<String, dynamic> json) => PenggunaModel(
        id: json['id'],
        idDepartemen: json['id_departemen'],
        nama: json['nama'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'Manajer',
      );
}
