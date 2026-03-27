const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Tu primera ruta (Endpoint)
app.get('/', (req, res) => {
  res.send('¡Servidor de G_P_Finance funcionando! 🚀');
});

// Configuración del puerto
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});
// homosexual