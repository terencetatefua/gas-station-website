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

### Application Directory

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




### Terraform Directory

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
hosted_zone_name   = "yourdomain.com"
subdomain_record   = "gasstation"
3️⃣ Secrets Manager Credentials
Manually create the RDS credentials secret:

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
Your Node.js app must be zipped and uploaded to S3.

📦 Zip your app
From the app/ directory:

bash
Copy
Edit
zip -r gasstation-app.zip . -x "*.env"
NOTE: .env is dynamically generated on the instance using the secret

☁️ Upload to S3
bash
Copy
Edit
aws s3 cp gasstation-app.zip s3://fuelmaxpro-app-artifacts/
5️⃣ SSH Key Pair (optional but useful)
To SSH into EC2, make sure you have a key pair created in your region.

Example (in terraform.tfvars)
hcl
Copy
Edit
key_name = "tristy"
6️⃣ Terraform Installed
Install Terraform CLI: 👉 https://developer.hashicorp.com/terraform/downloads

Test it:

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
Once deployed:

bash
Copy
Edit
curl https://gasstation.yourdomain.com/
# => Welcome to FuelMaxPro API 🚀
📄 API Endpoints
GET /stations — Get all stations

POST /stations — Add new station

Example payload:

json
Copy
Edit
{
  "name": "FuelX Premium",
  "location": "Miami, FL",
  "fuel_type": "Diesel"
}
🧹 Clean Up
To destroy everything:

bash
Copy
Edit
terraform destroy -auto-approve
👷‍♂️ Author
Developed by @terencetatefua
Built with ❤️ for cloud-native infrastructure!