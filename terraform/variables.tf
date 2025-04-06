variable "region" {
  default = "us-east-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_subnet_cidrs" {
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "availability_zones" {
  default = ["us-east-2a", "us-east-2b"]
}

variable "hosted_zone_name" {
  default = "tamispaj.com"
}

variable "subdomain_record" {
  default = "gasstation"
}

variable "app_bucket_name" {
  default = "fuelmaxpro-app-artifacts"
}
