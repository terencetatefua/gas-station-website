resource "aws_launch_template" "lt" {
  name_prefix   = "fuelmaxpro-nodejs-"
  image_id      = "ami-04f167a56786e4b09"
  instance_type = "t2.micro"
  key_name      = "tristy" # SSH key for manual login if needed

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(templatefile("${path.module}/bootstrap.sh", {
    app_bucket_name = var.app_bucket_name,
    db_host         = aws_db_instance.mysql.address,
    secret_id       = "fuelmaxpro-db-credentials",
    region          = "us-east-2"
  }))

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "fuelmaxpro-nodejs"
      Environment = "production"
      ManagedBy   = "Terraform"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "fuelmaxpro-asg"
  desired_capacity          = 2
  min_size                  = 2
  max_size                  = 4
  vpc_zone_identifier       = aws_subnet.private[*].id
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]

  tag {
    key                 = "Name"
    value               = "fuelmaxpro-node"
    propagate_at_launch = true
  }

  depends_on = [
    aws_launch_template.lt,
    aws_lb_target_group.tg
  ]
}
