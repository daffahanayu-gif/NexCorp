/// Tabel `detail_transaksi_kas`.
class TransaksiKasModel {
  final int _id;
  final int _idLaporan;
  final String _jenisArus; // 'Pemasukan' | 'Pengeluaran'
  String _keterangan;
  double _nominal;
  DateTime _tanggalTransaksi;

  TransaksiKasModel({
    required int id,
    required int idLaporan,
    required String jenisArus,
    required String keterangan,
    required double nominal,
    required DateTime tanggalTransaksi,
  })  : _id = id,
        _idLaporan = idLaporan,
        _jenisArus = jenisArus,
        _keterangan = keterangan,
        _nominal = nominal,
        _tanggalTransaksi = tanggalTransaksi;

  int get id => _id;
  int get idLaporan => _idLaporan;
  String get jenisArus => _jenisArus;
  String get keterangan => _keterangan;
  double get nominal => _nominal;
  DateTime get tanggalTransaksi => _tanggalTransaksi;
  bool get isPemasukan => _jenisArus == 'Pemasukan';

  set nominal(double val) {
    if (val >= 0) _nominal = val;
  }

  set keterangan(String val) {
    if (val.trim().isNotEmpty) _keterangan = val.trim();
  }

  factory TransaksiKasModel.fromJson(Map<String, dynamic> json) => TransaksiKasModel(
        id: json['id'],
        idLaporan: json['id_laporan'],
        jenisArus: json['jenis_arus'] ?? 'Pemasukan',
        keterangan: json['keterangan'] ?? '',
        nominal: double.tryParse(json['nominal'].toString()) ?? 0.0,
        tanggalTransaksi:
            DateTime.tryParse(json['tanggal_transaksi'].toString()) ?? DateTime.now(),
      );
}
