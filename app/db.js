require('dotenv').config();
const mysql = require('mysql2/promise');
const AWS = require('aws-sdk');

const secretName = "fuelmaxpro-db-credentials";
const region = "us-east-2";

const client = new AWS.SecretsManager({ region });

let pool;

async function getDbCredentials() {
  const data = await client.getSecretValue({ SecretId: secretName }).promise();
  const secret = JSON.parse(data.SecretString);
  return {
    user: secret.name,
    password: secret.password,
  };
}

async function initPool() {
  if (!pool) {
    const creds = await getDbCredentials();
    pool = mysql.createPool({
      host: process.env.DB_HOST,
      database: process.env.DB_NAME,
      user: creds.user,
      password: creds.password,
      waitForConnections: true,
      connectionLimit: 10,
    });
  }
}

module.exports = {
  query: async (...args) => {
    await initPool(); // Lazy init on first use
    const conn = await pool.getConnection();
    try {
      const [rows] = await conn.query(...args);
      return rows;
    } finally {
      conn.release();
    }
  },
};

// CREATE TABLE stations (
//   id INT AUTO_INCREMENT PRIMARY KEY,
//   name VARCHAR(255),
//   location VARCHAR(255),
//   fuel_type VARCHAR(100)
// );


// mysql -h fuelmaxpro-db.xxxxxx.us-east-2.rds.amazonaws.com -u admin -p