require('dotenv').config();
const express = require('express');
const path = require('path');
const app = express();
const stationsRoutes = require('./routes/stations');

app.use(express.json());
app.use('/stations', stationsRoutes);
app.use(express.static(path.join(__dirname, 'public')));

// Home Route
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'index.html'));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
