const pool = require("../db");

exports.getAll = async (req, res) => {
  const { id_perusahaan } = req.query;
  try {
    let query = `
      SELECT pr.*, p.kode_pt, p.nama_pt
      FROM proyek_operasional pr
      JOIN perusahaan p ON pr.id_perusahaan = p.id
    `;
    const params = [];
    if (id_perusahaan) {
      query += " WHERE pr.id_perusahaan = $1";
      params.push(id_perusahaan);
    }
    query += " ORDER BY pr.id DESC";

    const result = await pool.query(query, params);
    res.status(200).json({ status: "success", data: result.rows });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};

exports.create = async (req, res) => {
  const {
    id_perusahaan,
    nama_proyek,
    target_selesai,
    progres_persen,
    status_proyek,
  } = req.body;
  try {
    const result = await pool.query(
      `INSERT INTO proyek_operasional (id_perusahaan, nama_proyek, target_selesai, progres_persen, status_proyek)
       VALUES ($1, $2, $3, COALESCE($4, 0), COALESCE($5, 'Berjalan')) RETURNING *`,
      [
        id_perusahaan,
        nama_proyek,
        target_selesai,
        progres_persen,
        status_proyek,
      ],
    );
    res.status(201).json({ status: "success", data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};

exports.update = async (req, res) => {
  const { id } = req.params;
  const { progres_persen, status_proyek } = req.body;
  try {
    const result = await pool.query(
      `UPDATE proyek_operasional
       SET progres_persen = $1, status_proyek = $2
       WHERE id = $3 RETURNING *`,
      [progres_persen, status_proyek, id],
    );
    if (result.rows.length === 0) {
      return res
        .status(404)
        .json({ status: "error", message: "Proyek tidak ditemukan" });
    }
    res.status(200).json({ status: "success", data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};

exports.remove = async (req, res) => {
  try {
    const result = await pool.query(
      "DELETE FROM proyek_operasional WHERE id = $1 RETURNING *",
      [req.params.id],
    );
    if (result.rows.length === 0) {
      return res
        .status(404)
        .json({ status: "error", message: "Proyek tidak ditemukan" });
    }
    res
      .status(200)
      .json({ status: "success", message: "Proyek berhasil dihapus" });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};
