# FuelMaxPro API (MVP)

A Node.js + Express REST API for managing gas station locations.

## Endpoints

- GET `/stations` — List all stations
- POST `/stations` — Add a new station

## Env Vars

- DB_HOST
- DB_USER
- DB_PASS
- DB_NAME
- PORT

## Start the App

```bash
npm install
npm start



### sql query ###


---

# 🧠 Extras

### SQL to initialize DB on RDS:

```sql
CREATE TABLE stations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  location VARCHAR(255),
  fuel_type VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
