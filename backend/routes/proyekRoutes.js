const express = require("express");
const router = express.Router();
const proyekController = require("../controllers/proyekController");

router.get("/", proyekController.getAll);
router.post("/", proyekController.create);
router.put("/:id", proyekController.update);
router.delete("/:id", proyekController.remove);

module.exports = router;
