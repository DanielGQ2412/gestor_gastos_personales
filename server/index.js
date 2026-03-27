// ... (manten la conexión al pool que hicimos antes)

// MÓDULO 1: INGRESOS
app.post('/api/incomes', async (req, res) => {
  const { user_id, category_id, amount, frequency, note } = req.body;
  try {
      const newIncome = await pool.query(
          "INSERT INTO Transactions (user_id, category_id, amount, frequency, note, date) VALUES ($1, $2, $3, $4, $5, NOW()) RETURNING *",
          [user_id, category_id, amount, frequency, note]
      );
      res.json(newIncome.rows[0]);
  } catch (err) {
      console.error(err.message);
  }
});

// MÓDULO 2: GASTOS
app.post('/api/expenses', async (req, res) => {
  const { user_id, category_id, amount, note } = req.body;
  try {
      // Aquí podrías validar si supera el límite de la categoría (Alerta)
      const newExpense = await pool.query(
          "INSERT INTO Transactions (user_id, category_id, amount, note, date) VALUES ($1, $2, $3, $4, NOW()) RETURNING *",
          [user_id, category_id, -Math.abs(amount), note] // Guardamos como negativo
      );
      res.json(newExpense.rows[0]);
  } catch (err) {
      console.error(err.message);
  }
});

// MÓDULO 3: RESUMEN FINANCIERO (Balance Total)
// OBTENER RESUMEN POR PERIODO (Semanal, Mensual, etc.)
app.get('/api/summary/:userId', async (req, res) => {
  const { userId } = req.params;
  const { start_date, end_date } = req.query; // Ejemplo: ?start_date=2026-03-01&end_date=2026-03-31
  
  try {
      const result = await pool.query(
          `SELECT 
              SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) as total_incomes,
              SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) as total_expenses,
              SUM(amount) as net_balance
           FROM Transactions 
           WHERE user_id = $1 AND date BETWEEN $2 AND $3`,
          [userId, start_date, end_date]
      );
      res.json(result.rows[0]);
  } catch (err) {
      console.error(err.message);
      res.status(500).send("Error al obtener el resumen");
  }
});

// OBTENER GASTOS POR CATEGORÍA (Para el Gráfico de Pastel)
app.get('/api/expenses-by-category/:userId', async (req, res) => {
  try {
      const result = await pool.query(
          `SELECT c.name, SUM(ABS(t.amount)) as total
           FROM Transactions t
           JOIN Categories c ON t.category_id = c.id
           WHERE t.user_id = $1 AND t.amount < 0
           GROUP BY c.name`,
          [req.params.userId]
      );
      res.json(result.rows[0]);
  } catch (err) {
      console.error(err.message);
  }
});