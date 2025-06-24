const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Reserva = require('./Reserva');

const ServicoExtra = sequelize.define('ServicoExtra', {
  idServicoExtra: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  descricao: {
    type: DataTypes.STRING(45),
    allowNull: false,
  },
  valor: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true,
  },
}, {
  tableName: 'ServicoExtra',
  timestamps: false,
});



ServicoExtra.belongsToMany(Reserva, {
  through: 'ServicoExtra_has_Reserva',
  foreignKey: 'ServicoExtra_idServicoExtra',
  otherKey: 'Reserva_idReserva'
});

module.exports = ServicoExtra; 