# ⛽ FuelMaxPro — AWS Infrastructure + Node.js API

A cloud-native fuel station API deployed using **Terraform** and **Node.js**, hosted entirely on AWS.  
Features a MySQL backend, scalable Node.js API, custom domain routing, GitHub Actions CI/CD, and OWASP ZAP security scanning.

---

## 🌟 Features

- ⚙️ Infrastructure as Code (Terraform with remote S3 backend and DynamoDB locking)
- 💾 MySQL database on Amazon RDS
- 🛰 Node.js REST API deployed on EC2 Auto Scaling Groups
- 🔐 Secure credentials using AWS Secrets Manager
- 🌐 HTTPS via ACM + Route 53 DNS
- ☁️ Application artifact (ZIP) managed in S3 via CI/CD
- 🧪 OWASP ZAP Dynamic Application Security Testing (DAST)
- 🔁 Full CI/CD pipeline with GitHub Actions

---

## ✅ Prerequisites

Before running Terraform or pushing code, complete these **manual AWS Console setups**:

---

### 🛠️ Manual AWS Console Prerequisites

### 1. 📜 Route 53 Hosted Zone and Domain

- Buy or own a domain (e.g., `yourdomain.com`).
- Create a hosted zone in Route 53 for that domain.
- Record the domain and subdomain in `terraform.tfvars`:

```hcl
hosted_zone_name = "yourdomain.com"
subdomain_record = "gasstation"
```

---

### 2. 📦 Create S3 Bucket for Terraform State

- Go to **AWS Console → S3 → Create bucket**  
- Bucket Name: `fuelmaxpro-tf-state`  
- Region: `us-east-2 (Ohio)`

---

### 3. 🗄️ Create DynamoDB Table for Terraform Locking

- Go to **AWS Console → DynamoDB → Create table**  
- Table Name: `terraform-locks`  
- Partition Key:  
  - Name: `LockID`
  - Type: `String`

_Update backend block in `main.tf`:_

```hcl
terraform {
  backend "s3" {
    bucket         = "fuelmaxpro-tf-state"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

---

### 4. ☁️ Create S3 Bucket for App Artifact Storage

✅ No manual app upload needed anymore (handled by the pipeline).  
Create the bucket manually:

- Go to **AWS Console → S3 → Create Bucket**
- Bucket Name: `fuelmaxpro-app-artifacts`
- Region: `us-east-2 (Ohio)`

---

### 5. 🔐 Create Secrets Manager Secret for DB Credentials

- Go to **AWS Console → Secrets Manager → Store a new secret**
- Secret Name: `fuelmaxpro-db-credentials`
- Secret Value:

```json
{
  "name": "admin",
  "password": "YourSecurePassword123!"
}
```

---

### 6. 🔑 Create EC2 Key Pair

- Go to **AWS Console → EC2 → Key Pairs → Create Key Pair**
- Key Name: `tristy`
- Save the `.pem` file securely.

---

## 🧱 Terraform Setup

Install Terraform CLI version ≥ 1.3:

```bash
terraform version
```

---

## 🚀 Deploy Infrastructure

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

---

## 🌐 Test the API

```bash
curl https://gasstation.yourdomain.com/
```
![Test API](image.png)

---

## 📦 API Endpoints

| Method | Route        | Description            |
|--------|--------------|-------------------------|
| GET    | `/stations`  | List all fuel stations  |
| POST   | `/stations`  | Add a new station record |

---

## 🧪 Example POST Payload

```json
{
  "name": "FuelX Premium",
  "location": "Miami, FL",
  "fuel_type": "Diesel"
}
```

---

## 🔐 Environment Variables (.env)

The `.env` file is generated dynamically on the EC2 instance:

```env
DB_HOST=<your-rds-endpoint>
DB_USER=<username-from-secrets-manager>
DB_PASS=<password-from-secrets-manager>
DB_NAME=gasstations
PORT=3000
```

---

## 🧠 Manual SQL Schema Init (Optional)

```sql
CREATE DATABASE gasstations;

USE gasstations;

CREATE TABLE stations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  location VARCHAR(255),
  fuel_type VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
![SQL Schema Setup](image-4.png)

---

# 🔁 GitHub Actions CI/CD Pipeline

## 🛠️ How to Create the GitHub Actions Workflow (deploy-gas-station.website.yml)

If the GitHub Actions workflow does not exist yet, follow these steps:

1. Go to your **GitHub repository** (e.g., `https://github.com/your-repo-name`).

2. Click on the **Actions** tab at the top.

3. Click **"New Workflow"** or **"set up a workflow yourself"**.

4. Create a new file inside:
   ```
   .github/workflows/deploy-gas-station.website.yml
   ```

5. Paste your GitHub Actions YAML workflow (ZIP upload → Terraform → OWASP ZAP scan).

6. Commit the file to the `main` branch.

✅ Done! Now GitHub Actions triggers on every push!

---

![Workflow File Structure](045a47a4-f31e-4da1-b314-c0c8c3410180.png)

The GitHub Actions workflow at `.github/workflows/deploy-gas-station.website.yml` automates deployment on **every push to `main`**.

![GitHub Actions Overview](image-9.png)

---

## 📦 1. Upload Artifact to S3 (`upload-artifact`)

- Checkout repository
- Configure AWS credentials
- Validate `S3_BUCKET_NAME` secret
- Zip and upload app ZIP to S3 automatically

✅ No manual upload required!

---

## 🛠️ 2. Terraform Apply (`terraform-deploy`)

- Checkout repository
- Install Terraform
- Terraform `init` using S3 + DynamoDB backend
- Terraform `apply` infrastructure

---

## 🛡️ 3. DAST Scan with OWASP ZAP (`dast-scan`)

- Wait for EC2 app to be reachable
- Run dynamic OWASP ZAP scan
- Generate HTML/Markdown/JSON reports

---

### 📸 OWASP ZAP and Security Pipeline Screenshots

![Wait for App Ready](image-12.png)  
![Running OWASP ZAP](image-13.png)  
![ZAP Report Generated](image-14.png)  
![Upload ZAP Report](image-10.png)

---

## ✅ Pipeline Summary

| Stage            | Purpose                      | Output               |
|------------------|-------------------------------|-----------------------|
| upload-artifact  | Upload app ZIP to S3 bucket    | `gasstation-app.zip` |
| terraform-deploy | Deploy AWS infrastructure     | EC2, ALB, RDS created |
| dast-scan        | Run OWASP security scan        | `zap_report.html`    |

---

## 📁 Project Structure

```
app/
├── app.js               # Express app entry
├── db.js                # MySQL connection
├── package.json         # Node.js dependencies
├── routes/
│   └── stations.js      # API logic
├── public/
│   └── css/styles.css   # Static assets
├── views/
│   └── index.html       # Landing page
└── README.md            # Documentation
```

---

## 🧠 Git Workflow

```bash
# Clone repository
git clone https://github.com/terencetatefua/gas-station-website.git

cd gas-station-website

# Pull latest changes
git pull origin main
```
![Git Pull](image-8.png)

```bash
# Check repo status
git status
```
![Git Status](image-7.png)

```bash
# Stage changes
git add .
```
![Git Add](image-5.png)

```bash
# Commit changes
git commit -m "updated readme"
```
![Git Commit](image-6.png)

```bash
# Push changes
git push origin main
```
![Git Push](image-new.png) <!-- (your new Git push image) -->

---

## 🧹 Clean Up

To destroy the infrastructure:

```bash
terraform destroy -auto-approve
```
![Terraform Destroy](image-11.png)

---

## 👷‍♂️ Author

Built by **@terencetatefua**  
Built with ❤️ for cloud-native infrastructure.
