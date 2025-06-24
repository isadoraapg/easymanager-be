require('dotenv').config();
const express = require('express');
const cors = require('cors');
const sequelize = require('./config/database');
const { Produto } = require('./models');
const fs = require('fs');
const mysql = require('mysql2/promise');

const app = express();
app.use(cors({
  origin: 'http://localhost:5173',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// Rotas
app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/reservas', require('./routes/ReservaRoutes'));
app.use('/api/pagamentos', require('./routes/PagamentoRoutes'));
app.use('/api/hospedes', require('./routes/HospedeRoutes'));
app.use('/api/usuarios', require('./routes/UsuarioRoutes'));
app.use('/api/estoque', require('./routes/EstoqueItemRoutes'));


const PORT = process.env.PORT || 3000;

async function runSqlScriptIfNeeded() {
  if (process.env.CREATE_DB === 'true') {
    const sql = fs.readFileSync('./config/create_database.sql', 'utf8');
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASS,
      multipleStatements: true // Permite rodar vários comandos de uma vez
    });
    await connection.query(sql);
    await connection.end();
    console.log('Script de criação do banco executado com sucesso!');
  }
}

(async () => {
  await runSqlScriptIfNeeded();
  // ... o restante do seu código para iniciar o Express e sincronizar o Sequelize
  sequelize.sync()
    .then(() => {
      console.log('Banco sincronizado com sucesso.');
      app.listen(PORT, () => {
        console.log(`Servidor rodando na porta ${PORT}`);
      });
    })
    .catch(err => {
      console.error('Erro ao sincronizar banco:', err);
    });
})();

app.get('/', (req, res) => {
  res.send('EasyManager Backend funcionando!');
});

// Rota para criar produto
app.post('/produtos', async (req, res) => {
  try {
    const novoProduto = await Produto.create(req.body);
    res.status(201).json(novoProduto);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.get('/produtos', async (req, res) => {
  try {
    const produtos = await Produto.findAll();
    res.json(produtos);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
