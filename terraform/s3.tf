resource "aws_s3_bucket" "app" {
  bucket = var.app_bucket_name
  force_destroy = true
  tags = {
    Name = "fuelmaxpro-app-deploy"
  }
}
