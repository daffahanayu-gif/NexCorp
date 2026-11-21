const express = require("express");
const router = express.Router();
const ceoController = require("../controllers/ceoController");

router.get("/ringkasan", ceoController.getRingkasan);
router.get("/keuangan", ceoController.getKeuangan);

module.exports = router;
