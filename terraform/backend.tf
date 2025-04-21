terraform {
  backend "s3" {
    bucket         = "fuelmaxpro-app-artifacts"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "dynamodb-state-locking"  
  }
}
