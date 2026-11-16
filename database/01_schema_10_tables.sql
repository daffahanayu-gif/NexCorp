-- 1. Sektor Industri
CREATE TABLE sektor_industri (
  id SERIAL PRIMARY KEY,
  nama_sektor VARCHAR(60) UNIQUE NOT NULL,
  deskripsi_sektor TEXT
);

-- 2. Anak Perusahaan
CREATE TABLE perusahaan (
  id SERIAL PRIMARY KEY,
  id_sektor INT NOT NULL REFERENCES sektor_industri(id) ON DELETE RESTRICT,
  kode_pt VARCHAR(15) UNIQUE NOT NULL,
  nama_pt VARCHAR(100) NOT NULL,
  kota_pusat VARCHAR(50) NOT NULL,
  status_operasional VARCHAR(20) DEFAULT 'Aktif' CHECK (status_operasional IN ('Aktif', 'Restrukturisasi'))
);

-- 3. Departemen / Divisi Anak Perusahaan
CREATE TABLE departemen (
  id SERIAL PRIMARY KEY,
  id_perusahaan INT NOT NULL REFERENCES perusahaan(id) ON DELETE CASCADE,
  nama_departemen VARCHAR(60) NOT NULL,
  anggaran_tahunan NUMERIC(15,2) NOT NULL
);

-- 4. Pengguna (CEO Pusat & Manajer Departemen)
CREATE TABLE pengguna (
  id SERIAL PRIMARY KEY,
  id_departemen INT REFERENCES departemen(id) ON DELETE SET NULL,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('CEO', 'Manajer'))
);

-- 5. Proyek Operasional
CREATE TABLE proyek_operasional (
  id SERIAL PRIMARY KEY,
  id_perusahaan INT NOT NULL REFERENCES perusahaan(id) ON DELETE CASCADE,
  nama_proyek VARCHAR(120) NOT NULL,
  target_selesai DATE NOT NULL,
  progres_persen INT DEFAULT 0 CHECK (progres_persen BETWEEN 0 AND 100),
  status_proyek VARCHAR(25) DEFAULT 'Berjalan' CHECK (status_proyek IN ('Perencanaan', 'Berjalan', 'Selesai', 'Terhambat'))
);

-- 6. Milestone / Tahapan Proyek
CREATE TABLE milestone_proyek (
  id SERIAL PRIMARY KEY,
  id_proyek INT NOT NULL REFERENCES proyek_operasional(id) ON DELETE CASCADE,
  nama_tahapan VARCHAR(100) NOT NULL,
  bobot_persen INT NOT NULL CHECK (bobot_persen BETWEEN 1 AND 100),
  is_selesai BOOLEAN DEFAULT FALSE
);

-- 7. Laporan Keuangan Bulanan
CREATE TABLE laporan_keuangan (
  id SERIAL PRIMARY KEY,
  id_perusahaan INT NOT NULL REFERENCES perusahaan(id) ON DELETE CASCADE,
  bulan_tahun VARCHAR(20) NOT NULL,
  status_audit VARCHAR(20) DEFAULT 'Verified' CHECK (status_audit IN ('Draft', 'Verified'))
);

-- 8. Detail Transaksi Kas (Pemasukan & Pengeluaran)
CREATE TABLE detail_transaksi_kas (
  id SERIAL PRIMARY KEY,
  id_laporan INT NOT NULL REFERENCES laporan_keuangan(id) ON DELETE CASCADE,
  jenis_arus VARCHAR(15) NOT NULL CHECK (jenis_arus IN ('Pemasukan', 'Pengeluaran')),
  keterangan VARCHAR(150) NOT NULL,
  nominal NUMERIC(15,2) NOT NULL,
  tanggal_transaksi DATE NOT NULL
);

-- 9. Pengajuan Approval ke CEO
CREATE TABLE pengajuan_approval (
  id SERIAL PRIMARY KEY,
  id_proyek INT NOT NULL REFERENCES proyek_operasional(id) ON DELETE CASCADE,
  id_pemohon INT NOT NULL REFERENCES pengguna(id) ON DELETE CASCADE,
  jenis_pengajuan VARCHAR(60) NOT NULL,
  nominal NUMERIC(15,2) NOT NULL,
  catatan TEXT,
  status_approval VARCHAR(20) DEFAULT 'Pending' CHECK (status_approval IN ('Pending', 'Approved', 'Rejected'))
);

-- 10. Aset Perusahaan
CREATE TABLE aset_perusahaan (
  id SERIAL PRIMARY KEY,
  id_perusahaan INT NOT NULL REFERENCES perusahaan(id) ON DELETE CASCADE,
  nama_aset VARCHAR(100) NOT NULL,
  kategori_aset VARCHAR(40) NOT NULL,
  nilai_valuasi NUMERIC(15,2) NOT NULL,
  kondisi VARCHAR(20) DEFAULT 'Baik' CHECK (kondisi IN ('Baik', 'Perlu Perawatan'))
);