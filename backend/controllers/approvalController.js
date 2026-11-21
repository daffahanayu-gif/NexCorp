const pool = require("../db");

exports.getAll = async (req, res) => {
  const { status } = req.query;
  try {
    let query = `
      SELECT pa.id AS id_approval, pa.status_approval, p.nama_pt, d.nama_departemen,
             u.nama AS pemohon, pr.nama_proyek, pa.jenis_pengajuan, pa.nominal, pa.catatan
      FROM pengajuan_approval pa
      JOIN proyek_operasional pr ON pa.id_proyek = pr.id
      JOIN perusahaan p ON pr.id_perusahaan = p.id
      JOIN pengguna u ON pa.id_pemohon = u.id
      LEFT JOIN departemen d ON u.id_departemen = d.id
    `;
    const params = [];
    if (status) {
      query += " WHERE pa.status_approval = $1";
      params.push(status);
    }
    query += " ORDER BY pa.id DESC";

    const result = await pool.query(query, params);
    res.status(200).json({ status: "success", data: result.rows });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};

exports.create = async (req, res) => {
  const { id_proyek, id_pemohon, jenis_pengajuan, nominal, catatan } = req.body;
  try {
    const result = await pool.query(
      `INSERT INTO pengajuan_approval (id_proyek, id_pemohon, jenis_pengajuan, nominal, catatan)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [id_proyek, id_pemohon, jenis_pengajuan, nominal, catatan],
    );
    res.status(201).json({ status: "success", data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};

exports.updateStatus = async (req, res) => {
  const { status_approval } = req.body; // 'Approved' atau 'Rejected'
  try {
    const result = await pool.query(
      `UPDATE pengajuan_approval SET status_approval = $1 WHERE id = $2 RETURNING *`,
      [status_approval, req.params.id],
    );
    if (result.rows.length === 0) {
      return res
        .status(404)
        .json({
          status: "error",
          message: "Pengajuan approval tidak ditemukan",
        });
    }
    res.status(200).json({ status: "success", data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};
