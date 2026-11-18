-- 1. Sektor Industri
INSERT INTO sektor_industri (nama_sektor, deskripsi_sektor) VALUES
('Teknologi & IT', 'Pengembangan perangkat lunak, cloud, dan solusi AI'),
('Logistik & Ekspedisi', 'Distribusi barang, pergudangan, dan armada transportasi'),
('Properti & Konstruksi', 'Pengembangan kawasan komersial dan hunian'),
('Food & Beverage', 'Jaringan restoran, katering korporat, dan produk pangan'),
('Keuangan & Investasi', 'Pendanaan modal ventura dan layanan finansial');

-- 2. Anak Perusahaan
INSERT INTO perusahaan (id_sektor, kode_pt, nama_pt, kota_pusat, status_operasional) VALUES
(1, 'NX-TECH', 'PT NexCorp Digital Teknologi', 'Jakarta', 'Aktif'),
(2, 'NX-LOG',  'PT NexCorp Logistik Nusantara', 'Surabaya', 'Aktif'),
(3, 'NX-PROP', 'PT NexCorp Graha Properti', 'Madiun', 'Aktif'),
(4, 'NX-FNB',  'PT NexCorp Boga Mandiri', 'Bandung', 'Restrukturisasi'),
(5, 'NX-FIN',  'PT NexCorp Ventura Kapital', 'Jakarta', 'Aktif');

-- 3. Departemen Tiap Perusahaan
INSERT INTO departemen (id_perusahaan, nama_departemen, anggaran_tahunan) VALUES
(1, 'Engineering & Cloud', 1200000000),
(2, 'Operasional & Armada', 950000000),
(3, 'Pengembangan Proyek', 2500000000),
(4, 'Produksi & Outlet', 600000000),
(5, 'Analisis Investasi', 800000000);

-- 4. Pengguna (1 CEO Pusat + 5 Manajer Anak PT)
INSERT INTO pengguna (id_departemen, nama, email, password, role) VALUES
(NULL, 'Daffa Hanayu (CEO)', 'ceo@nexcorp.id', 'ceo123', 'CEO'),
(1, 'Budi Santoso', 'budi.tech@nexcorp.id', 'manajer123', 'Manajer'),
(2, 'Siti Aminah', 'siti.log@nexcorp.id', 'manajer123', 'Manajer'),
(3, 'Hendra Wijaya', 'hendra.prop@nexcorp.id', 'manajer123', 'Manajer'),
(4, 'Rina Kartika', 'rina.fnb@nexcorp.id', 'manajer123', 'Manajer'),
(5, 'Dimas Pratama', 'dimas.fin@nexcorp.id', 'manajer123', 'Manajer');

-- 5. Proyek Operasional
INSERT INTO proyek_operasional (id_perusahaan, nama_proyek, target_selesai, progres_persen, status_proyek) VALUES
(1, 'Migrasi Cloud Server & AI Analytics', '2026-12-15', 85, 'Berjalan'),
(2, 'Ekspansi Gudang Otomatis Surabaya', '2026-12-20', 60, 'Berjalan'),
(3, 'Pembangunan Kawasan Komersial Madiun', '2027-03-10', 40, 'Berjalan'),
(4, 'Revitalisasi Menu & Efisiensi Outlet', '2026-12-05', 25, 'Terhambat'),
(5, 'Peluncuran Dana Investasi UMKM', '2027-01-15', 15, 'Perencanaan');

-- 6. Milestone Proyek
INSERT INTO milestone_proyek (id_proyek, nama_tahapan, bobot_persen, is_selesai) VALUES
(1, 'Setup Infrastruktur Cloud', 50, TRUE),
(1, 'Integrasi Pipeline AI', 50, FALSE),
(2, 'Pembebasan Lahan & Izin', 40, TRUE),
(2, 'Instalasi Rak Otomatis', 60, FALSE),
(3, 'Pekerjaan Fondasi & Struktur', 40, TRUE);

-- 7. Laporan Keuangan Bulanan
INSERT INTO laporan_keuangan (id_perusahaan, bulan_tahun, status_audit) VALUES
(1, 'November 2026', 'Verified'),
(2, 'November 2026', 'Verified'),
(3, 'November 2026', 'Verified'),
(4, 'November 2026', 'Verified'),
(5, 'November 2026', 'Draft');

-- 8. Detail Transaksi Kas
INSERT INTO detail_transaksi_kas (id_laporan, jenis_arus, keterangan, nominal, tanggal_transaksi) VALUES
(1, 'Pemasukan', 'Kontrak SaaS Enterprise Q4', 920000000, '2026-11-05'),
(1, 'Pengeluaran', 'Biaya Server & Gaji Engineer', 450000000, '2026-11-10'),
(2, 'Pemasukan', 'Pendapatan Kargo Ekspres', 710000000, '2026-11-08'),
(2, 'Pengeluaran', 'BBM & Perawatan Armada', 410000000, '2026-11-12'),
(3, 'Pemasukan', 'Penjualan Unit Ruko Tahap 1', 1200000000, '2026-11-04'),
(3, 'Pengeluaran', 'Material Konstruksi', 750000000, '2026-11-14'),
(4, 'Pemasukan', 'Omzet Seluruh Cabang F&B', 310000000, '2026-11-09'),
(4, 'Pengeluaran', 'Bahan Baku & Sewa Ruko', 360000000, '2026-11-15');

-- 9. Pengajuan Approval ke CEO
INSERT INTO pengajuan_approval (id_proyek, id_pemohon, jenis_pengajuan, nominal, catatan, status_approval) VALUES
(1, 2, 'Penambahan Anggaran GPU Server', 150000000, 'Dibutuhkan untuk training model analitik', 'Pending'),
(2, 3, 'Pembelian 10 Unit Forklift Listrik', 450000000, 'Mempercepat bongkar muat gudang', 'Pending'),
(3, 4, 'Pencairan Termin 2 Kontraktor', 800000000, 'Progres struktur sudah mencapai 40%', 'Approved'),
(4, 5, 'Dana Promosi Rebranding F&B', 75000000, 'Mendongkrak penjualan akhir tahun', 'Rejected');

-- 10. Aset Perusahaan
INSERT INTO aset_perusahaan (id_perusahaan, nama_aset, kategori_aset, nilai_valuasi, kondisi) VALUES
(1, 'Data Center Tier-3 Jakarta', 'Infrastruktur IT', 3500000000, 'Baik'),
(2, '25 Truk Kontainer Pendingin', 'Armada Kendaraan', 6200000000, 'Baik'),
(3, 'Lahan Komersial 2 Hektar Madiun', 'Tanah & Bangunan', 12000000000, 'Baik'),
(4, 'Central Kitchen Bandung', 'Pabrik & Dapur', 1400000000, 'Perlu Perawatan');