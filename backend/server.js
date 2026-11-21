const express = require("express");
const cors = require("cors");
require("dotenv").config();
const pool = require("./db");

const authRoutes = require("./routes/authRoutes");
const ceoRoutes = require("./routes/ceoRoutes");
const perusahaanRoutes = require("./routes/perusahaanRoutes");
const proyekRoutes = require("./routes/proyekRoutes");
const approvalRoutes = require("./routes/approvalRoutes");

const app = express();
app.use(cors());
app.use(express.json());

// Endpoint tes koneksi
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

// Mount semua routes
app.use("/api", authRoutes);
app.use("/api/ceo", ceoRoutes);
app.use("/api/perusahaan", perusahaanRoutes);
app.use("/api/proyek", proyekRoutes);
app.use("/api/approval", approvalRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () =>
  console.log(`NexCorp API aktif di http://localhost:${PORT}`),
);
