const pool = require("../db");

exports.getAll = async (req, res) => {
  try {
    const query = `
      SELECT p.*, s.nama_sektor
      FROM perusahaan p
      JOIN sektor_industri s ON p.id_sektor = s.id
      ORDER BY p.id ASC
    `;
    const result = await pool.query(query);
    res.status(200).json({ status: "success", data: result.rows });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};

exports.getById = async (req, res) => {
  const { id } = req.params;
  try {
    const ptRes = await pool.query(
      `SELECT p.*, s.nama_sektor FROM perusahaan p JOIN sektor_industri s ON p.id_sektor = s.id WHERE p.id = $1`,
      [id],
    );
    if (ptRes.rows.length === 0) {
      return res
        .status(404)
        .json({ status: "error", message: "Perusahaan tidak ditemukan" });
    }
    const proyekRes = await pool.query(
      `SELECT * FROM proyek_operasional WHERE id_perusahaan = $1 ORDER BY id ASC`,
      [id],
    );
    res.status(200).json({
      status: "success",
      data: { ...ptRes.rows[0], proyek: proyekRes.rows },
    });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};

exports.create = async (req, res) => {
  const { id_sektor, kode_pt, nama_pt, kota_pusat, status_operasional } =
    req.body;
  try {
    const result = await pool.query(
      `INSERT INTO perusahaan (id_sektor, kode_pt, nama_pt, kota_pusat, status_operasional)
       VALUES ($1, $2, $3, $4, COALESCE($5, 'Aktif')) RETURNING *`,
      [id_sektor, kode_pt, nama_pt, kota_pusat, status_operasional],
    );
    res.status(201).json({ status: "success", data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};

exports.update = async (req, res) => {
  const { id } = req.params;
  const { id_sektor, kode_pt, nama_pt, kota_pusat, status_operasional } =
    req.body;
  try {
    const result = await pool.query(
      `UPDATE perusahaan
       SET id_sektor = $1, kode_pt = $2, nama_pt = $3, kota_pusat = $4, status_operasional = $5
       WHERE id = $6 RETURNING *`,
      [id_sektor, kode_pt, nama_pt, kota_pusat, status_operasional, id],
    );
    if (result.rows.length === 0) {
      return res
        .status(404)
        .json({ status: "error", message: "Perusahaan tidak ditemukan" });
    }
    res.status(200).json({ status: "success", data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};

exports.remove = async (req, res) => {
  try {
    const result = await pool.query(
      "DELETE FROM perusahaan WHERE id = $1 RETURNING *",
      [req.params.id],
    );
    if (result.rows.length === 0) {
      return res
        .status(404)
        .json({ status: "error", message: "Perusahaan tidak ditemukan" });
    }
    res
      .status(200)
      .json({ status: "success", message: "Perusahaan berhasil dihapus" });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};
