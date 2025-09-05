const express = require('express');
const cors = require('cors');
const requestRoutes = require('./routes/requestRoutes');

const app = express();

app.use(express.json()); 
app.use(cors());       

app.use('/api', requestRoutes);

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Refactored server is running on http://localhost:${PORT}`);
});

