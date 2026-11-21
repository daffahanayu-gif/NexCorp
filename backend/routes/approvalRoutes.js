const express = require("express");
const router = express.Router();
const approvalController = require("../controllers/approvalController");

router.get("/", approvalController.getAll);
router.post("/", approvalController.create);
router.put("/:id", approvalController.updateStatus);

module.exports = router;
