const { EstoqueItem } = require('../models');

const EstoqueItemController = {
  async criar(req, res) {
    try {
      const novoItem = await EstoqueItem.create(req.body);
      res.status(201).json(novoItem);
    } catch (error) {
      console.error('Erro ao criar item no estoque:', error);
      res.status(400).json({ error: error.message });
    }
  },

  async listar(req, res) {
    try {
      const itens = await EstoqueItem.findAll();
      res.json(itens);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
};

module.exports = EstoqueItemController;
