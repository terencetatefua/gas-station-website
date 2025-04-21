#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "🚀 Starting instance bootstrap..."

# 🧱 Install system dependencies
apt-get update -y
apt-get install -y unzip curl jq mysql-client build-essential

# 🛠 Install AWS CLI manually (Ubuntu 24.04 fix)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
export PATH=$PATH:/usr/local/bin

# 🟢 Install Node.js + PM2
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
npm install -g pm2

# 🔐 Fetch credentials from AWS Secrets Manager
SECRET_ID="${secret_id}"
REGION="${region}"
MAX_RETRIES=5

for ((i=1; i<=MAX_RETRIES; i++)); do
  echo "🔐 Attempt $i to fetch secret..."
  SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id "$SECRET_ID" --region "$REGION" --query 'SecretString' --output text 2>/dev/null) && break || sleep 5
done

if [ -z "$SECRET_JSON" ]; then
  echo "❌ Failed to fetch secret after $MAX_RETRIES attempts."
  exit 1
fi

DB_USER=$(echo "$SECRET_JSON" | jq -r .name)
DB_PASS=$(echo "$SECRET_JSON" | jq -r .password)

# 📦 Prepare app directory
mkdir -p /home/ubuntu/app
cd /home/ubuntu
echo "⬇️ Downloading app from S3..."
aws s3 cp s3://${app_bucket_name}/latest/gasstation-app.zip app.zip
unzip -q app.zip -d app

# 🧪 Write .env file
cat <<EOT > /home/ubuntu/app/.env
DB_HOST=${db_host}
DB_USER=$DB_USER
DB_PASS=$DB_PASS
DB_NAME=gasstations
PORT=3000
EOT

# 🔐 Ownership
chown -R ubuntu:ubuntu /home/ubuntu/app

# ✅ Write and run safe startup script as ubuntu
cat <<'EOT' > /home/ubuntu/app/start.sh
#!/bin/bash
cd /home/ubuntu/app
echo "📦 Installing dependencies..."
npm install
echo "🚦 Launching app with PM2..."
pm2 start app.js
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save
EOT

chmod +x /home/ubuntu/app/start.sh
chown ubuntu:ubuntu /home/ubuntu/app/start.sh
sudo -u ubuntu /home/ubuntu/app/start.sh

echo "✅ Bootstrap complete"
