import '../models/pengguna_model.dart';

/// Hasil login: data `pengguna` + perusahaan/departemen tempat Manajer bertugas.
/// Tabel pengguna hanya menyimpan id_departemen; id_perusahaan didapat dari
/// JOIN departemen (API login mengembalikan keduanya).
class SesiPengguna {
  final PenggunaModel _pengguna;
  final int? _idPerusahaan;
  final String _namaPt;
  final String _namaDepartemen;

  SesiPengguna({
    required PenggunaModel pengguna,
    int? idPerusahaan,
    String namaPt = '',
    String namaDepartemen = '',
  })  : _pengguna = pengguna,
        _idPerusahaan = idPerusahaan,
        _namaPt = namaPt,
        _namaDepartemen = namaDepartemen;

  PenggunaModel get pengguna => _pengguna;
  int get id => _pengguna.id;
  String get nama => _pengguna.nama;
  bool get isCeo => _pengguna.isCeo;
  int? get idPerusahaan => _idPerusahaan;
  String get namaPt => _namaPt;
  String get namaDepartemen => _namaDepartemen;

  /// JSON dari POST /api/login: {id, nama, email, role, id_departemen,
  /// id_perusahaan, nama_pt, nama_departemen}
  factory SesiPengguna.fromJson(Map<String, dynamic> json) => SesiPengguna(
        pengguna: PenggunaModel.fromJson(json),
        idPerusahaan: int.tryParse('${json['id_perusahaan']}'),
        namaPt: json['nama_pt']?.toString() ?? '',
        namaDepartemen: json['nama_departemen']?.toString() ?? '',
      );
}
