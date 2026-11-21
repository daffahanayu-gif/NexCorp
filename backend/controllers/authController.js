const pool = require("../db");

exports.login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const query = `
      SELECT u.id, u.nama, u.email, u.role, u.id_departemen, d.id_perusahaan
      FROM pengguna u
      LEFT JOIN departemen d ON u.id_departemen = d.id
      WHERE u.email = $1 AND u.password = $2
    `;
    const result = await pool.query(query, [email, password]);

    if (result.rows.length === 0) {
      return res
        .status(401)
        .json({ status: "error", message: "Email atau password salah" });
    }

    res.status(200).json({ status: "success", data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
};
