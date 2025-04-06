data "aws_secretsmanager_secret" "db_credentials" {
  name = "fuelmaxpro-db-credentials"
}

data "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_credentials_version.secret_string)
}
