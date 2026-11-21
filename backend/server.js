const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

// Endpoint tes koneksi & cek tabel perusahaan
app.get("/api/health", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT COUNT(*) AS total_pt FROM perusahaan",
    );
    res.status(200).json({
      status: "success",
      message: "NexCorp API terhubung ke Supabase!",
      data: result.rows[0],
    });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () =>
  console.log(`NexCorp API aktif di http://localhost:${PORT}`),
);
