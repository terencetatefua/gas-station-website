resource "aws_lb" "alb" {
  name               = "fuelmaxpro-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id

  tags = {
    Name        = "fuelmaxpro-alb"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "fuelmaxpro-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "fuelmaxpro-target-group"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
