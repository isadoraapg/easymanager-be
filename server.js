require('dotenv').config();
const express = require('express');
const cors = require('cors');
const fs = require('fs');
const mysql = require('mysql2/promise');

const {
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
  Quarto_has_Reserva
} = require('./models');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({
  origin: 'http://localhost:5173',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// ======================
// Definição de relações
// ======================

// Reserva → Hospede
Reserva.belongsTo(Hospede, { foreignKey: 'hospedeId' });
Hospede.hasMany(Reserva, { foreignKey: 'hospedeId' });

// Reserva ↔ ServicoExtra
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

// EstoqueItem ↔ ServicoExtra
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

// Quarto ↔ Reserva
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

// Hospede ↔ Reserva (extra)
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

// ======================
// Rotas
// ======================
app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/reservas', require('./routes/ReservaRoutes'));
app.use('/api/pagamentos', require('./routes/PagamentoRoutes'));
app.use('/api/hospedes', require('./routes/HospedeRoutes'));
app.use('/api/usuarios', require('./routes/UsuarioRoutes'));
app.use('/api/estoque', require('./routes/EstoqueItemRoutes'));

// ======================
// Executar script SQL se necessário
// ======================
async function runSqlScriptIfNeeded() {
  if (process.env.CREATE_DB === 'true') {
    const sql = fs.readFileSync('./config/create_database.sql', 'utf8');
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASS,
      multipleStatements: true
    });
    await connection.query(sql);
    await connection.end();
    console.log('Script de criação do banco executado com sucesso!');
  }
}

// ======================
// Inicializar servidor e sincronizar banco
// ======================
(async () => {
  await runSqlScriptIfNeeded();

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

// ======================
// Rotas simples
// ======================
app.get('/', (req, res) => {
  res.send('EasyManager Backend funcionando!');
});

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
