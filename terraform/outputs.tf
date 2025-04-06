output "application_url" {
  value = "https://${aws_route53_record.gasstation.name}"
}

output "rds_endpoint" {
  value       = aws_db_instance.mysql.address
  description = "The endpoint of the MySQL RDS instance"
}


output "iam_role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "iam_instance_profile" {
  description = "Instance profile name"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
