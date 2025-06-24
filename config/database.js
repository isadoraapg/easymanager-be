const { Sequelize } = require('sequelize');
require('dotenv').config();

const sequelize = new Sequelize(
  process.env.DB_NAME,  // Nome do banco de dados
  process.env.DB_USER,  // Usuário do banco
  process.env.DB_PASS,  // Senha do banco
  {
    host: process.env.DB_HOST,  // Endereço do banco fornecido pelo Render
    port: process.env.DB_PORT,  // Porta do banco (provavelmente 5432)
    dialect: 'postgres',
    dialectOptions: {
      ssl: {
        require: true,
        rejectUnauthorized: false  // Em ambientes de produção, isso pode ser ajustado conforme a segurança exigida
      }
    },
    logging: false,
    define: {
      timestamps: true,
      underscored: false, // ou true, conforme sua preferência
    }
  }
);

module.exports = sequelize;
