# ⛽ FuelMaxPro API (MVP)

A lightweight **Node.js + Express** REST API for managing gas station data. Built as part of the FuelMaxPro infrastructure project, this backend powers data operations like listing and adding new fuel stations.

---

## 📦 Endpoints

| Method | Route       | Description              |
|--------|-------------|--------------------------|
| GET    | `/stations` | List all stations        |
| POST   | `/stations` | Add a new station record |

---

## 🔐 Environment Variables (`.env`)

The app expects the following environment variables, injected dynamically by the EC2 instance during bootstrap via AWS Secrets Manager:

```env
DB_HOST=<your-rds-endpoint>
DB_USER=<username-from-secrets-manager>
DB_PASS=<password-from-secrets-manager>
DB_NAME=gasstations
PORT=3000
✅ .env file is created automatically by the bootstrap script — no need to commit it manually.

🚀 Start the App Locally
bash
Copy
Edit
npm install
npm start
The app will run on http://localhost:3000 by default.

🧠 Database Init: SQL Schema
To manually initialize the database (e.g., via MySQL Workbench or the CLI), run:

sql
Copy
Edit
CREATE DATABASE gasstations;

USE gasstations;

CREATE TABLE stations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  location VARCHAR(255),
  fuel_type VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
🧪 Example POST Payload
json
Copy
Edit
{
  "name": "FuelX Premium",
  "location": "Miami, FL",
  "fuel_type": "Diesel"
}
📁 File Structure
bash
Copy
Edit
app/
├── app.js               # Express app entry point
├── db.js                # MySQL connection using AWS Secrets Manager
├── package.json         # Node.js dependencies
├── routes/
│   └── stations.js      # API logic
├── public/
│   └── css/styles.css   # Frontend style
├── views/
│   └── index.html       # Landing page (static)
└── README.md            # You are here!