import '../models/pengajuan_model.dart';
import '../models/pengguna_model.dart';
import '../models/proyek_model.dart';

class PerusahaanRingkas {
  final int id;
  final String namaPt;
  const PerusahaanRingkas(this.id, this.namaPt);
}

class DepartemenRingkas {
  final int id;
  final int idPerusahaan;
  final String namaDepartemen;
  const DepartemenRingkas(this.id, this.idPerusahaan, this.namaDepartemen);
}

/// Data dummy di memori untuk mode demo (tanpa backend). Struktur mengikuti
/// skema: pengguna -> departemen -> perusahaan -> proyek -> pengajuan_approval.
class DummyStore {
  DummyStore._();
  static final DummyStore instance = DummyStore._();

  final List<PerusahaanRingkas> perusahaan = const [
    PerusahaanRingkas(1, 'PT Nusantara Tech'),
    PerusahaanRingkas(2, 'PT Maju Logistik'),
    PerusahaanRingkas(3, 'PT Graha Properti'),
    PerusahaanRingkas(4, 'CV Rasa Antara'),
    PerusahaanRingkas(5, 'PT Digdaya Software'),
  ];

  final List<DepartemenRingkas> departemen = const [
    DepartemenRingkas(1, 1, 'Engineering'),
    DepartemenRingkas(2, 1, 'Keuangan'),
    DepartemenRingkas(3, 2, 'Operasional'),
    DepartemenRingkas(4, 2, 'Keuangan'),
    DepartemenRingkas(5, 3, 'Pemasaran'),
    DepartemenRingkas(6, 3, 'Konstruksi'),
    DepartemenRingkas(7, 4, 'Operasional'),
    DepartemenRingkas(8, 5, 'Engineering'),
  ];

  final List<PenggunaModel> pengguna = [
    PenggunaModel(id: 1, nama: 'CEO Holding', email: 'ceo@nexcorp.id', role: 'CEO'),
    PenggunaModel(id: 2, idDepartemen: 1, nama: 'Rina Wijaya', email: 'rina@nusantaratech.id', role: 'Manajer'),
    PenggunaModel(id: 3, idDepartemen: 3, nama: 'Bagas Pratama', email: 'bagas@majulogistik.id', role: 'Manajer'),
    PenggunaModel(id: 4, idDepartemen: 5, nama: 'Sinta Maharani', email: 'sinta@grahaproperti.id', role: 'Manajer'),
    PenggunaModel(id: 5, idDepartemen: 7, nama: 'Dimas Hartono', email: 'dimas@rasaantara.id', role: 'Manajer'),
  ];

  final List<ProyekModel> proyek = [
    ProyekModel(id: 1, idPerusahaan: 1, namaProyek: 'Platform E-Procurement', targetSelesai: DateTime(2027, 3, 31), progresPersen: 75, statusProyek: 'Berjalan'),
    ProyekModel(id: 2, idPerusahaan: 1, namaProyek: 'Migrasi Cloud Internal', targetSelesai: DateTime(2026, 10, 15), progresPersen: 85, statusProyek: 'Terhambat'),
    ProyekModel(id: 3, idPerusahaan: 2, namaProyek: 'Sistem Pelacakan Armada', targetSelesai: DateTime(2027, 1, 20), progresPersen: 55, statusProyek: 'Berjalan'),
    ProyekModel(id: 4, idPerusahaan: 2, namaProyek: 'Gudang Otomatis Cikarang', targetSelesai: DateTime(2027, 6, 30), progresPersen: 20, statusProyek: 'Perencanaan'),
    ProyekModel(id: 5, idPerusahaan: 3, namaProyek: 'Klaster Residensial Bogor', targetSelesai: DateTime(2027, 9, 1), progresPersen: 40, statusProyek: 'Berjalan'),
    ProyekModel(id: 6, idPerusahaan: 3, namaProyek: 'Renovasi Gedung Kantor Pusat', targetSelesai: DateTime(2026, 8, 30), progresPersen: 100, statusProyek: 'Selesai'),
    ProyekModel(id: 7, idPerusahaan: 4, namaProyek: 'Ekspansi 10 Gerai Baru', targetSelesai: DateTime(2027, 2, 28), progresPersen: 15, statusProyek: 'Terhambat'),
    ProyekModel(id: 8, idPerusahaan: 5, namaProyek: 'Aplikasi Mobile Banking Mitra', targetSelesai: DateTime(2027, 4, 30), progresPersen: 63, statusProyek: 'Berjalan'),
  ];

  final List<PengajuanModel> pengajuan = [
    PengajuanModel(id: 1, idProyek: 1, idPemohon: 2, namaProyek: 'Platform E-Procurement', namaPt: 'PT Nusantara Tech', namaPemohon: 'Rina Wijaya', jenisPengajuan: 'Tambahan Anggaran', nominal: 250000000, catatan: 'Penambahan 3 developer untuk mengejar target Q1.'),
    PengajuanModel(id: 2, idProyek: 4, idPemohon: 3, namaProyek: 'Gudang Otomatis Cikarang', namaPt: 'PT Maju Logistik', namaPemohon: 'Bagas Pratama', jenisPengajuan: 'Pengadaan Alat', nominal: 1200000000, catatan: 'Pembelian sistem konveyor dan sensor.'),
    PengajuanModel(id: 3, idProyek: 7, idPemohon: 5, namaProyek: 'Ekspansi 10 Gerai Baru', namaPt: 'CV Rasa Antara', namaPemohon: 'Dimas Hartono', jenisPengajuan: 'Dana Ekspansi', nominal: 800000000, catatan: 'Sewa lokasi dan renovasi tahap awal.'),
    PengajuanModel(id: 4, idProyek: 5, idPemohon: 4, namaProyek: 'Klaster Residensial Bogor', namaPt: 'PT Graha Properti', namaPemohon: 'Sinta Maharani', jenisPengajuan: 'Perpanjangan Target', nominal: 0, catatan: 'Izin lingkungan mundur 2 bulan.', statusApproval: 'Approved'),
  ];

  int idProyekBerikutnya() => proyek.fold<int>(0, (a, p) => p.id > a ? p.id : a) + 1;
  int idPengajuanBerikutnya() => pengajuan.fold<int>(0, (a, p) => p.id > a ? p.id : a) + 1;
}
