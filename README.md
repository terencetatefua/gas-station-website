# ⛽ FuelMaxPro — AWS Infrastructure + Node.js API

A complete cloud-native fuel station API application deployed using **Terraform** and **Node.js**, hosted on AWS infrastructure. It includes a secure MySQL RDS backend, PM2-managed Node.js service on EC2, and HTTPS routing via ALB + Route 53.

---

## 🌟 Features

- ⚙️ Infrastructure-as-Code with Terraform  
- 🛰 Fully managed EC2 deployment with auto-scaling  
- 🔐 Secure credentials from Secrets Manager  
- 💾 MySQL database on RDS  
- 🌐 Custom domain support via Route 53 + ACM  
- ☁️ Application zipped and deployed from S3  
- 📊 API to manage fuel stations  
- 🖼 Simple front-end page included (HTML + CSS)

---

## 📁 Folder Structure

### 📁 `app/` Directory (Descending Order)

```
app/  
├── views/  
│   └── index.html  
├── routes/  
│   └── stations.js  
├── public/  
│   └── css/  
│       └── styles.css  
├── package.json  
├── gasstation-app.zip  
├── db.js  
├── app.js  
├── README.md
```

### 📁 `terraform/` Directory

```
terraform/  
├── vpc.tf  
├── variables.tf  
├── terraform.tfvars  
├── secret.tf  
├── rds.tf  
├── outputs.tf  
├── iam.tf  
├── ec2.tf  
├── bootstrap.sh  
├── alb.tf  
├── route53.tf
```

---

## ✅ Prerequisites

Before deploying this project, ensure the following are in place:

### 1️⃣ AWS Credentials

Ensure you're authenticated with AWS:

```bash
aws configure
```

Or use an IAM role if deploying from CI/CD or Terraform Cloud.

---

### 2️⃣ Existing Route 53 Hosted Zone

You must already own a domain hosted in AWS Route 53 (e.g. yourdomain.com).  
Terraform will:

- Create `gasstation.yourdomain.com`  
- Request an ACM SSL certificate  
- Update your `terraform.tfvars`:

```hcl
hosted_zone_name = "yourdomain.com"
subdomain_record = "gasstation"
```

---

### 3️⃣ Secrets Manager Credentials

Manually create the RDS credentials secret in AWS Secrets Manager.

**Secret name:**
```
fuelmaxpro-db-credentials
```

**Secret value (JSON):**
```json
{
  "name": "admin",
  "password": "YourSecurePassword123!"
}
```

---

### 4️⃣ Zip the Application & Upload to S3

From within the `app/` directory:

```bash
zip -r gasstation-app.zip . -x "*.env"
```

Then upload to your S3 bucket (e.g. `fuelmaxpro-app-artifacts`):

```bash
aws s3 cp gasstation-app.zip s3://fuelmaxpro-app-artifacts/
```

---

### 5️⃣ SSH Key Pair

Make sure you have a key pair in your AWS region to enable SSH access.  
Add it to your `terraform.tfvars`:

```hcl
key_name = "tristy"
```

---

### 6️⃣ Terraform Installed

Install Terraform CLI 👉 [Download Terraform](https://developer.hashicorp.com/terraform/downloads)

Verify installation:

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

Once deployed, you should be able to access your endpoint:

```bash
curl https://gasstation.yourdomain.com/
# => Welcome to FuelMaxPro API 🚀
```

---

## 📄 API Endpoints

- `GET /stations`  
  ➡️ Get all stations

- `POST /stations`  
  ➡️ Add a new station

**Sample payload:**

```json
{
  "name": "FuelX Premium",
  "location": "Miami, FL",
  "fuel_type": "Diesel"
}
```

---

## 🧠 SQL to Initialize RDS

If needed, log in to the RDS instance and manually initialize the DB:

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

---

## 🧹 Clean Up

To tear down everything:

```bash
terraform destroy -auto-approve
```

---

## 👷‍♂️ Author

Developed by **@terencetatefua**  
Built with ❤️ for cloud-native infrastructure.
