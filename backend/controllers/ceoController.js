const pool = require("../db");

exports.getRingkasan = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM view_ringkasan_holding ORDER BY id ASC",
    );
    res.status(200).json({ status: "success", data: result.rows });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};

exports.getKeuangan = async (req, res) => {
  try {
    const query = `
      SELECT s.nama_sektor, p.id, p.kode_pt, p.nama_pt,
             COALESCE(SUM(CASE WHEN dtk.jenis_arus = 'Pemasukan' THEN dtk.nominal ELSE 0 END), 0) AS total_pemasukan,
             COALESCE(SUM(CASE WHEN dtk.jenis_arus = 'Pengeluaran' THEN dtk.nominal ELSE 0 END), 0) AS total_pengeluaran,
             COALESCE(SUM(CASE WHEN dtk.jenis_arus = 'Pemasukan' THEN dtk.nominal ELSE -dtk.nominal END), 0) AS laba_bersih,
             COALESCE((SELECT SUM(nilai_valuasi) FROM aset_perusahaan ap WHERE ap.id_perusahaan = p.id), 0) AS total_valuasi_aset
      FROM perusahaan p
      JOIN sektor_industri s ON p.id_sektor = s.id
      LEFT JOIN laporan_keuangan lk ON p.id = lk.id_perusahaan
      LEFT JOIN detail_transaksi_kas dtk ON lk.id = dtk.id_laporan
      GROUP BY s.nama_sektor, p.id, p.kode_pt, p.nama_pt
      ORDER BY laba_bersih DESC
    `;
    const result = await pool.query(query);
    res.status(200).json({ status: "success", data: result.rows });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};
