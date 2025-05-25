const express = require('express');
const mysql = require('mysql2');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

// Set up MySQL connection
const connection = mysql.createConnection({
  host: 'terraform-20250524015716400100000009.c21oe22ccugw.us-east-1.rds.amazonaws.com',
  user: process.env.username,
  password: process.env.password,
  database: 'myrds'
});

// Connect to the database
connection.connect(err => {
  if (err) {
    console.error('Database connection failed:', err.stack);
    return;
  }
  console.log('Connected to the database.');
});
app.use(express.static(path.join(__dirname)));

// Serve the index.html file
app.get('/', (req, res) => {
  const filePath = path.join(__dirname, 'index.html');
  fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
      res.status(500).send('Error reading index.html');
      return;
    }
    res.send(data);
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
