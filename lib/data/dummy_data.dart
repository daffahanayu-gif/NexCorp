import '../models/aset_model.dart';
import '../models/departemen_model.dart';
import '../models/laporan_keuangan_model.dart';
import '../models/milestone_model.dart';
import '../models/pengajuan_model.dart';
import '../models/pengguna_model.dart';
import '../models/perusahaan_model.dart';
import '../models/proyek_model.dart';
import '../models/sektor_model.dart';
import '../models/transaksi_kas_model.dart';

List<SektorModel> buatDummySektor() => [
      SektorModel(id: 1, namaSektor: 'Teknologi'),
      SektorModel(id: 2, namaSektor: 'Logistik'),
      SektorModel(id: 3, namaSektor: 'Properti'),
      SektorModel(id: 4, namaSektor: 'F&B'),
    ];

List<PerusahaanModel> buatDummyPerusahaan() => [
      PerusahaanModel(id: 1, idSektor: 1, namaSektor: 'Teknologi', kodePt: 'NTK-01', namaPt: 'PT Nusantara Tech', kotaPusat: 'Jakarta Selatan'),
      PerusahaanModel(id: 2, idSektor: 2, namaSektor: 'Logistik', kodePt: 'MLG-02', namaPt: 'PT Maju Logistik', kotaPusat: 'Bekasi'),
      PerusahaanModel(id: 3, idSektor: 3, namaSektor: 'Properti', kodePt: 'GPR-03', namaPt: 'PT Graha Properti', kotaPusat: 'Bogor'),
      PerusahaanModel(id: 4, idSektor: 4, namaSektor: 'F&B', kodePt: 'RSA-04', namaPt: 'CV Rasa Antara', kotaPusat: 'Bandung', statusOperasional: 'Restrukturisasi'),
      PerusahaanModel(id: 5, idSektor: 1, namaSektor: 'Teknologi', kodePt: 'DIG-05', namaPt: 'PT Digdaya Software', kotaPusat: 'Yogyakarta'),
    ];

List<DepartemenModel> buatDummyDepartemen() => [
      DepartemenModel(id: 1, idPerusahaan: 1, namaDepartemen: 'Engineering', anggaranTahunan: 4800000000),
      DepartemenModel(id: 2, idPerusahaan: 1, namaDepartemen: 'Keuangan', anggaranTahunan: 900000000),
      DepartemenModel(id: 3, idPerusahaan: 2, namaDepartemen: 'Operasional', anggaranTahunan: 9500000000),
      DepartemenModel(id: 4, idPerusahaan: 2, namaDepartemen: 'Keuangan', anggaranTahunan: 700000000),
      DepartemenModel(id: 5, idPerusahaan: 3, namaDepartemen: 'Pemasaran', anggaranTahunan: 2200000000),
      DepartemenModel(id: 6, idPerusahaan: 3, namaDepartemen: 'Konstruksi', anggaranTahunan: 15000000000),
      DepartemenModel(id: 7, idPerusahaan: 4, namaDepartemen: 'Operasional', anggaranTahunan: 6000000000),
      DepartemenModel(id: 8, idPerusahaan: 5, namaDepartemen: 'Engineering', anggaranTahunan: 3600000000),
    ];

/// Dipakai nanti oleh login (Dev 4 / Dev 2). Password tidak dimodelkan.
List<PenggunaModel> buatDummyPengguna() => [
      PenggunaModel(id: 1, nama: 'CEO Holding', email: 'ceo@nexcorp.id', role: 'CEO'),
      PenggunaModel(id: 2, idDepartemen: 1, nama: 'Rina Wijaya', email: 'rina@nusantaratech.id', role: 'Manajer'),
      PenggunaModel(id: 3, idDepartemen: 3, nama: 'Bagas Pratama', email: 'bagas@majulogistik.id', role: 'Manajer'),
      PenggunaModel(id: 4, idDepartemen: 5, nama: 'Sinta Maharani', email: 'sinta@grahaproperti.id', role: 'Manajer'),
      PenggunaModel(id: 5, idDepartemen: 7, nama: 'Dimas Hartono', email: 'dimas@rasaantara.id', role: 'Manajer'),
    ];

List<ProyekModel> buatDummyProyek() => [
      ProyekModel(id: 1, idPerusahaan: 1, namaProyek: 'Platform E-Procurement', targetSelesai: DateTime(2027, 3, 31), progresPersen: 75, statusProyek: 'Berjalan'),
      ProyekModel(id: 2, idPerusahaan: 1, namaProyek: 'Migrasi Cloud Internal', targetSelesai: DateTime(2026, 10, 15), progresPersen: 85, statusProyek: 'Terhambat'),
      ProyekModel(id: 3, idPerusahaan: 2, namaProyek: 'Sistem Pelacakan Armada', targetSelesai: DateTime(2027, 1, 20), progresPersen: 55, statusProyek: 'Berjalan'),
      ProyekModel(id: 4, idPerusahaan: 2, namaProyek: 'Gudang Otomatis Cikarang', targetSelesai: DateTime(2027, 6, 30), progresPersen: 20, statusProyek: 'Perencanaan'),
      ProyekModel(id: 5, idPerusahaan: 3, namaProyek: 'Klaster Residensial Bogor', targetSelesai: DateTime(2027, 9, 1), progresPersen: 40, statusProyek: 'Berjalan'),
      ProyekModel(id: 6, idPerusahaan: 3, namaProyek: 'Renovasi Gedung Kantor Pusat', targetSelesai: DateTime(2026, 8, 30), progresPersen: 100, statusProyek: 'Selesai'),
      ProyekModel(id: 7, idPerusahaan: 4, namaProyek: 'Ekspansi 10 Gerai Baru', targetSelesai: DateTime(2027, 2, 28), progresPersen: 15, statusProyek: 'Terhambat'),
      ProyekModel(id: 8, idPerusahaan: 5, namaProyek: 'Aplikasi Mobile Banking Mitra', targetSelesai: DateTime(2027, 4, 30), progresPersen: 63, statusProyek: 'Berjalan'),
    ];

MilestoneModel _m(int id, int proyek, String nama, int bobot, bool selesai) =>
    MilestoneModel(id: id, idProyek: proyek, namaTahapan: nama, bobotPersen: bobot, isSelesai: selesai);

List<MilestoneModel> buatDummyMilestone() => [
      _m(1, 1, 'Analisis kebutuhan', 20, true),
      _m(2, 1, 'Desain sistem', 20, true),
      _m(3, 1, 'Pengembangan modul', 35, true),
      _m(4, 1, 'Uji coba dan peluncuran', 25, false),
      _m(5, 2, 'Audit infrastruktur lama', 30, true),
      _m(6, 2, 'Pemindahan data', 25, true),
      _m(7, 2, 'Pengujian performa', 30, true),
      _m(8, 2, 'Pemutusan server lama', 15, false),
      _m(9, 3, 'Pengadaan perangkat GPS', 15, true),
      _m(10, 3, 'Integrasi aplikasi', 40, true),
      _m(11, 3, 'Pelatihan sopir', 30, false),
      _m(12, 3, 'Peluncuran seluruh armada', 15, false),
      _m(13, 7, 'Survei lokasi', 15, true),
      _m(14, 7, 'Perizinan dan sewa', 35, false),
      _m(15, 7, 'Renovasi dan pembukaan', 50, false),
      _m(16, 8, 'Riset kebutuhan mitra', 20, true),
      _m(17, 8, 'Desain antarmuka', 25, true),
      _m(18, 8, 'Pengembangan fitur inti', 18, true),
      _m(19, 8, 'Uji keamanan dan rilis', 37, false),
    ];

int _idTransaksi = 0;

LaporanKeuanganModel _laporan(int id, int idPt, String bulan, String status, double masuk, double keluar) {
  final tgl = bulan.split('-');
  final y = int.parse(tgl[0]);
  final m = int.parse(tgl[1]);
  TransaksiKasModel t(String jenis, String ket, double nominal, int hari) => TransaksiKasModel(
        id: ++_idTransaksi,
        idLaporan: id,
        jenisArus: jenis,
        keterangan: ket,
        nominal: nominal,
        tanggalTransaksi: DateTime(y, m, hari),
      );
  return LaporanKeuanganModel(
    id: id,
    idPerusahaan: idPt,
    bulanTahun: bulan,
    statusAudit: status,
    transaksi: [
      t('Pemasukan', 'Pendapatan utama', masuk * 0.7, 5),
      t('Pemasukan', 'Pendapatan lain-lain', masuk * 0.3, 18),
      t('Pengeluaran', 'Biaya operasional', keluar * 0.6, 10),
      t('Pengeluaran', 'Gaji dan tunjangan', keluar * 0.4, 25),
    ],
  );
}

List<LaporanKeuanganModel> buatDummyLaporan() {
  _idTransaksi = 0;
  return [
    _laporan(1, 1, '2026-10', 'Verified', 1850000000, 1250000000),
    _laporan(2, 1, '2026-11', 'Draft', 1900000000, 1300000000),
    _laporan(3, 2, '2026-10', 'Verified', 2400000000, 2100000000),
    _laporan(4, 2, '2026-11', 'Draft', 2500000000, 2300000000),
    _laporan(5, 3, '2026-10', 'Verified', 3200000000, 2400000000),
    _laporan(6, 3, '2026-11', 'Draft', 2900000000, 2500000000),
    _laporan(7, 4, '2026-10', 'Verified', 900000000, 1100000000),
    _laporan(8, 4, '2026-11', 'Draft', 850000000, 1000000000),
    _laporan(9, 5, '2026-10', 'Verified', 1200000000, 800000000),
    _laporan(10, 5, '2026-11', 'Draft', 1300000000, 850000000),
  ];
}

List<AsetModel> buatDummyAset() => [
      AsetModel(id: 1, idPerusahaan: 1, namaAset: 'Server Rack Data Center', kategoriAset: 'Infrastruktur TI', nilaiValuasi: 3200000000),
      AsetModel(id: 2, idPerusahaan: 1, namaAset: 'Gedung Kantor Sudirman', kategoriAset: 'Properti', nilaiValuasi: 18000000000),
      AsetModel(id: 3, idPerusahaan: 2, namaAset: 'Armada Truk 40 Unit', kategoriAset: 'Kendaraan', nilaiValuasi: 12500000000, kondisi: 'Perlu Perawatan'),
      AsetModel(id: 4, idPerusahaan: 2, namaAset: 'Gudang Bekasi', kategoriAset: 'Properti', nilaiValuasi: 9000000000),
      AsetModel(id: 5, idPerusahaan: 3, namaAset: 'Lahan Pengembangan Bogor', kategoriAset: 'Lahan', nilaiValuasi: 40000000000),
      AsetModel(id: 6, idPerusahaan: 4, namaAset: 'Dapur Pusat Produksi', kategoriAset: 'Peralatan', nilaiValuasi: 2800000000, kondisi: 'Perlu Perawatan'),
      AsetModel(id: 7, idPerusahaan: 5, namaAset: 'Laptop dan Workstation Tim', kategoriAset: 'Peralatan', nilaiValuasi: 850000000),
    ];

List<PengajuanModel> buatDummyPengajuan() => [
      PengajuanModel(id: 1, idProyek: 1, idPemohon: 2, namaProyek: 'Platform E-Procurement', namaPt: 'PT Nusantara Tech', namaPemohon: 'Rina Wijaya', jenisPengajuan: 'Tambahan Anggaran', nominal: 250000000, catatan: 'Penambahan 3 developer untuk mengejar target Q1.'),
      PengajuanModel(id: 2, idProyek: 4, idPemohon: 3, namaProyek: 'Gudang Otomatis Cikarang', namaPt: 'PT Maju Logistik', namaPemohon: 'Bagas Pratama', jenisPengajuan: 'Pengadaan Alat', nominal: 1200000000, catatan: 'Pembelian sistem konveyor dan sensor.'),
      PengajuanModel(id: 3, idProyek: 7, idPemohon: 5, namaProyek: 'Ekspansi 10 Gerai Baru', namaPt: 'CV Rasa Antara', namaPemohon: 'Dimas Hartono', jenisPengajuan: 'Dana Ekspansi', nominal: 800000000, catatan: 'Sewa lokasi dan renovasi tahap awal.'),
      PengajuanModel(id: 4, idProyek: 5, idPemohon: 4, namaProyek: 'Klaster Residensial Bogor', namaPt: 'PT Graha Properti', namaPemohon: 'Sinta Maharani', jenisPengajuan: 'Perpanjangan Target', nominal: 0, catatan: 'Izin lingkungan mundur 2 bulan.', statusApproval: 'Approved'),
    ];
