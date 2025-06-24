const { Sequelize, DataTypes } = require('sequelize');
const sequelize = require('../config/database');

// Importação dos models
const Endereco = require('./Endereco');
const Usuario = require('./Usuario');
const Fornecedor = require('./Fornecedor');
const Hospede = require('./Hospede');
const EstoqueItem = require('./EstoqueItem');
const Reserva = require('./Reserva');
const ServicoExtra = require('./ServicoExtra');
const Pagamento = require('./Pagamento');
const Quarto = require('./Quarto');
const ServicoExtra_has_Reserva = require('./ServicoExtra_has_Reserva');
const Hospede_has_Reserva = require('./Hospede_has_Reserva');
const EstoqueItem_has_ServicoExtra = require('./EstoqueItem_has_ServicoExtra');
const Quarto_has_Reserva = require('./Quarto_has_Reserva');

// Produto
const Produto = sequelize.define('Produto', {
  nome_item: { type: DataTypes.STRING(255), allowNull: false },
  quantidade: { type: DataTypes.INTEGER, allowNull: false },
  preco: { type: DataTypes.DECIMAL(10, 2), allowNull: false },
  data_validade: { type: DataTypes.DATE, allowNull: true },
}, {
  tableName: 'produtos',
  timestamps: true,
});

// =========================
// DEFININDO RELACIONAMENTOS
// =========================

Reserva.belongsTo(Hospede, { foreignKey: 'hospedeId' });
Hospede.hasMany(Reserva, { foreignKey: 'hospedeId' });

Reserva.belongsToMany(ServicoExtra, {
  through: ServicoExtra_has_Reserva,
  foreignKey: 'Reserva_idReserva',
  otherKey: 'ServicoExtra_idServicoExtra',
});
ServicoExtra.belongsToMany(Reserva, {
  through: ServicoExtra_has_Reserva,
  foreignKey: 'ServicoExtra_idServicoExtra',
  otherKey: 'Reserva_idReserva',
});

EstoqueItem.belongsToMany(ServicoExtra, {
  through: EstoqueItem_has_ServicoExtra,
  foreignKey: 'EstoqueItem_idEstoqueItem',
  otherKey: 'ServicoExtra_idServicoExtra',
});
ServicoExtra.belongsToMany(EstoqueItem, {
  through: EstoqueItem_has_ServicoExtra,
  foreignKey: 'ServicoExtra_idServicoExtra',
  otherKey: 'EstoqueItem_idEstoqueItem',
});

Quarto.belongsToMany(Reserva, {
  through: Quarto_has_Reserva,
  foreignKey: 'Quarto_idQuarto',
  otherKey: 'Reserva_idReserva',
});
Reserva.belongsToMany(Quarto, {
  through: Quarto_has_Reserva,
  foreignKey: 'Reserva_idReserva',
  otherKey: 'Quarto_idQuarto',
});

Hospede.belongsToMany(Reserva, {
  through: Hospede_has_Reserva,
  foreignKey: 'Hospede_idHospede',
  otherKey: 'Reserva_idReserva',
});
Reserva.belongsToMany(Hospede, {
  through: Hospede_has_Reserva,
  foreignKey: 'Reserva_idReserva',
  otherKey: 'Hospede_idHospede',
});

// Exportando tudo
module.exports = {
  sequelize,
  Produto,
  Endereco,
  Usuario,
  Fornecedor,
  Hospede,
  EstoqueItem,
  Reserva,
  ServicoExtra,
  Pagamento,
  Quarto,
  ServicoExtra_has_Reserva,
  Hospede_has_Reserva,
  EstoqueItem_has_ServicoExtra,
  Quarto_has_Reserva,
};
