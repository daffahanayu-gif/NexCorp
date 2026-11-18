import 'transaksi_kas_model.dart';

/// Tabel `laporan_keuangan`. Total pemasukan/pengeluaran/laba DIHITUNG dari
/// `detail_transaksi_kas` (tidak disimpan di tabel).
class LaporanKeuanganModel {
  final int _id;
  final int _idPerusahaan;
  String _bulanTahun; // disarankan format YYYY-MM
  String _statusAudit; // 'Draft' | 'Verified'
  final List<TransaksiKasModel> _transaksi;

  LaporanKeuanganModel({
    required int id,
    required int idPerusahaan,
    required String bulanTahun,
    String statusAudit = 'Draft',
    List<TransaksiKasModel>? transaksi,
  })  : _id = id,
        _idPerusahaan = idPerusahaan,
        _bulanTahun = bulanTahun,
        _statusAudit = statusAudit,
        _transaksi = transaksi ?? [];

  int get id => _id;
  int get idPerusahaan => _idPerusahaan;
  String get bulanTahun => _bulanTahun;
  String get statusAudit => _statusAudit;
  List<TransaksiKasModel> get transaksi => List.unmodifiable(_transaksi);

  set statusAudit(String val) {
    if (val == 'Draft' || val == 'Verified') _statusAudit = val;
  }

  void tambahTransaksi(TransaksiKasModel t) => _transaksi.add(t);

  double get totalPemasukan => _transaksi
      .where((t) => t.isPemasukan)
      .fold<double>(0, (a, t) => a + t.nominal);

  double get totalPengeluaran => _transaksi
      .where((t) => !t.isPemasukan)
      .fold<double>(0, (a, t) => a + t.nominal);

  double get labaBersih => totalPemasukan - totalPengeluaran;
  bool get isVerified => _statusAudit == 'Verified';

  factory LaporanKeuanganModel.fromJson(Map<String, dynamic> json) {
    final list = (json['transaksi'] as List?) ?? [];
    return LaporanKeuanganModel(
      id: json['id'],
      idPerusahaan: json['id_perusahaan'],
      bulanTahun: json['bulan_tahun'] ?? '',
      statusAudit: json['status_audit'] ?? 'Draft',
      transaksi: list
          .map((e) => TransaksiKasModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
