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

app/ ├── views/ │ └── index.html ├── routes/ │ └── stations.js ├── public/ │ └── css/ │ └── styles.css ├── package.json ├── gasstation-app.zip ├── db.js ├── app.js ├── README.md

shell
Copy
Edit

### 📁 `terraform/` Directory

terraform/ ├── vpc.tf ├── variables.tf ├── terraform.tfvars ├── secret.tf ├── rds.tf ├── outputs.tf ├── iam.tf ├── ec2.tf ├── bootstrap.sh ├── alb.tf ├── route53.tf

yaml
Copy
Edit

---

## ✅ Prerequisites

Before deploying this project, ensure the following are in place:

### 1️⃣ AWS Credentials

Ensure you are authenticated with AWS:

```bash
aws configure
Or use an IAM role if deploying from CI/CD or Terraform Cloud.

2️⃣ Existing Route 53 Hosted Zone
You must already own a domain hosted in AWS Route 53 (e.g. yourdomain.com).

Terraform will:

Create gasstation.yourdomain.com

Request a certificate via ACM

Update your terraform.tfvars:

hcl
Copy
Edit
hosted_zone_name = "yourdomain.com"
subdomain_record = "gasstation"
3️⃣ Secrets Manager Credentials
Manually create the RDS credentials secret.

🔐 Secret Name
Copy
Edit
fuelmaxpro-db-credentials
🔑 Secret Value (JSON)
json
Copy
Edit
{
  "name": "admin",
  "password": "YourSecurePassword123!"
}
4️⃣ Zip the Application for EC2 Bootstrap
From the app/ directory:

bash
Copy
Edit
zip -r gasstation-app.zip . -x "*.env"
Then upload it to S3:

bash
Copy
Edit
aws s3 cp gasstation-app.zip s3://fuelmaxpro-app-artifacts/
5️⃣ SSH Key Pair
Make sure your AWS region has a key pair available for EC2 SSH access.

In terraform.tfvars:

hcl
Copy
Edit
key_name = "tristy"
6️⃣ Terraform Installed
Install Terraform CLI 👉 https://developer.hashicorp.com/terraform/downloads

Check installation:

bash
Copy
Edit
terraform version
🚀 Deploy Infrastructure
bash
Copy
Edit
cd terraform
terraform init
terraform apply -auto-approve
🌐 Test the API
bash
Copy
Edit
curl https://gasstation.yourdomain.com/
# => Welcome to FuelMaxPro API 🚀
📄 API Endpoints
GET /stations — Get all stations

POST /stations — Add new station

Sample Payload
json
Copy
Edit
{
  "name": "FuelX Premium",
  "location": "Miami, FL",
  "fuel_type": "Diesel"
}
🧠 SQL to Initialize RDS Table
If needed, log in to RDS and create your table manually:

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
🧹 Clean Up
bash
Copy
Edit
terraform destroy -auto-approve
👷‍♂️ Author
Developed by @terencetatefua
Built with ❤️ for cloud-native infrastructure.