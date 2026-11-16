-- QUERY 1: Rekap Laba Bersih & Valuasi Aset Tiap Anak Perusahaan (JOIN 5 Tabel)
SELECT s.nama_sektor, p.kode_pt, p.nama_pt,
       COALESCE(SUM(CASE WHEN dtk.jenis_arus = 'Pemasukan' THEN dtk.nominal ELSE 0 END), 0) AS total_pemasukan,
       COALESCE(SUM(CASE WHEN dtk.jenis_arus = 'Pengeluaran' THEN dtk.nominal ELSE 0 END), 0) AS total_pengeluaran,
       COALESCE(SUM(CASE WHEN dtk.jenis_arus = 'Pemasukan' THEN dtk.nominal ELSE -dtk.nominal END), 0) AS laba_bersih,
       COALESCE((SELECT SUM(nilai_valuasi) FROM aset_perusahaan ap WHERE ap.id_perusahaan = p.id), 0) AS total_valuasi_aset
FROM perusahaan p
JOIN sektor_industri s ON p.id_sektor = s.id
LEFT JOIN laporan_keuangan lk ON p.id = lk.id_perusahaan
LEFT JOIN detail_transaksi_kas dtk ON lk.id = dtk.id_laporan
GROUP BY s.nama_sektor, p.id, p.kode_pt, p.nama_pt
ORDER BY laba_bersih DESC;

-- QUERY 2: Daftar Pengajuan Approval 'Pending' Lengkap dengan Nama Pemohon, Departemen, Proyek, & PT (JOIN 5 Tabel)
SELECT pa.id AS id_approval, p.nama_pt, d.nama_departemen, u.nama AS pemohon,
       pr.nama_proyek, pa.jenis_pengajuan, pa.nominal, pa.catatan
FROM pengajuan_approval pa
JOIN proyek_operasional pr ON pa.id_proyek = pr.id
JOIN perusahaan p ON pr.id_perusahaan = p.id
JOIN pengguna u ON pa.id_pemohon = u.id
LEFT JOIN departemen d ON u.id_departemen = d.id
WHERE pa.status_approval = 'Pending'
ORDER BY pa.nominal DESC;

-- QUERY 3: Monitoring Bobot Milestone yang Sudah Selesai vs Total Bobot Tiap Proyek
SELECT p.kode_pt, pr.nama_proyek, pr.progres_persen AS progres_laporan_manajer,
       COALESCE(SUM(CASE WHEN mp.is_selesai = TRUE THEN mp.bobot_persen ELSE 0 END), 0) AS bobot_milestone_selesai,
       COUNT(mp.id) AS total_tahapan
FROM proyek_operasional pr
JOIN perusahaan p ON pr.id_perusahaan = p.id
LEFT JOIN milestone_proyek mp ON pr.id = mp.id_proyek
GROUP BY p.kode_pt, pr.id, pr.nama_proyek, pr.progres_persen;

-- QUERY 4: Evaluasi Anggaran Tahunan Departemen vs Pengajuan Dana Proyek
SELECT p.nama_pt, d.nama_departemen, d.anggaran_tahunan,
       COALESCE(SUM(pa.nominal), 0) AS total_dana_diajukan,
       CASE
         WHEN COALESCE(SUM(pa.nominal), 0) > (d.anggaran_tahunan * 0.5) THEN 'Perhatian CEO (Pengajuan > 50% Anggaran)'
         ELSE 'Aman (Dalam Batas Wajar)'
       END AS status_pengawasan
FROM departemen d
JOIN perusahaan p ON d.id_perusahaan = p.id
LEFT JOIN pengguna u ON d.id = u.id_departemen
LEFT JOIN pengajuan_approval pa ON u.id = pa.id_pemohon
GROUP BY p.nama_pt, d.id, d.nama_departemen, d.anggaran_tahunan;

-- QUERY 5: Membuat SQL VIEW Ringkasan Eksekutif CEO (Siap Dipanggil Dev 2 di Backend)
CREATE OR REPLACE VIEW view_ringkasan_holding AS
SELECT p.id, p.kode_pt, p.nama_pt, s.nama_sektor, p.kota_pusat, p.status_operasional,
       COUNT(DISTINCT pr.id) AS jumlah_proyek,
       COALESCE(ROUND(AVG(pr.progres_persen), 1), 0) AS rata_progres_proyek
FROM perusahaan p
JOIN sektor_industri s ON p.id_sektor = s.id
LEFT JOIN proyek_operasional pr ON p.id = pr.id_perusahaan
GROUP BY p.id, p.kode_pt, p.nama_pt, s.nama_sektor, p.kota_pusat, p.status_operasional;

-- Cek isi VIEW
SELECT * FROM view_ringkasan_holding;