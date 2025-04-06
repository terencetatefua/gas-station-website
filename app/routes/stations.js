const express = require('express');
const router = express.Router();
const db = require('../db');

// GET /stations
router.get('/', async (req, res) => {
  const [rows] = await db.query('SELECT * FROM stations');
  res.json(rows);
});

// POST /stations
router.post('/', async (req, res) => {
  const { name, location, fuel_type } = req.body;
  const [result] = await db.query(
    'INSERT INTO stations (name, location, fuel_type) VALUES (?, ?, ?)',
    [name, location, fuel_type]
  );
  res.json({ id: result.insertId });
});

module.exports = router;
