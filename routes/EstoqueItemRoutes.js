const express = require('express');
const router = express.Router();
const EstoqueItemController = require('../controllers/EstoqueItemController');

router.post('/', EstoqueItemController.criar);
router.get('/', EstoqueItemController.listar); // opcional

module.exports = router;