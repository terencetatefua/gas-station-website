# 1. Lookup existing hosted zone (e.g., tamispaj.com)
data "aws_route53_zone" "selected" {
  name         = var.hosted_zone_name     # e.g. "tamispaj.com"
  private_zone = false
}

# 2. Request ACM certificate for subdomain (e.g., gasstation.tamispaj.com)
resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.subdomain_record}.${var.hosted_zone_name}" # gasstation.tamispaj.com
  validation_method = "DNS"

  tags = {
    Name = "fuelmaxpro-cert"
  }
}

# 3. Create validation record (ACM will provide DNS records to validate the cert)
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

# 4. Complete certificate validation once DNS is set
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# 5. Application Load Balancer - already defined elsewhere (make sure it's public!)
# resource "aws_lb" "alb" {...}

# 6. Create HTTPS listener on the ALB (uses validated certificate)
resource "aws_lb_listener" "https" {
  depends_on        = [aws_acm_certificate_validation.cert_validation]
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# 7. Create HTTP listener to redirect all traffic to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# 8. Create a Route 53 record for the subdomain to point to the ALB
resource "aws_route53_record" "gasstation" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.subdomain_record}.${var.hosted_zone_name}"  # gasstation.tamispaj.com
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
