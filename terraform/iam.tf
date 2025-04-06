resource "aws_iam_role" "ec2_role" {
  name = "fuelmaxpro-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "fuelmaxpro-ec2-role"
    Project     = "FuelMaxPro"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "fuelmaxpro-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name        = "fuelmaxpro-ec2-profile"
    Project     = "FuelMaxPro"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# ✅ SSM Session Manager access
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ✅ S3 read access for app artifacts
resource "aws_iam_policy" "s3_read" {
  name = "fuelmaxpro-app-read-s3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject"],
        Resource = "arn:aws:s3:::fuelmaxpro-app-artifacts/*"
      }
    ]
  })

  tags = {
    Name        = "fuelmaxpro-app-read-s3"
    Project     = "FuelMaxPro"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read.arn
}

# ✅ Secrets Manager read access
resource "aws_iam_policy" "secretsmanager_read" {
  name = "fuelmaxpro-read-secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["secretsmanager:GetSecretValue"],
        Resource = "arn:aws:secretsmanager:us-east-2:975050147953:secret:fuelmaxpro-db-credentials-MEof7c"
      }
    ]
  })

  tags = {
    Name        = "fuelmaxpro-read-secrets"
    Project     = "FuelMaxPro"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "secrets_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secretsmanager_read.arn
}
