
resource "aws_acm_certificate" "cert" {
  domain_name       = "*.sre-assignment.click"
  subject_alternative_names = ["api.sre-assignment.click"]
  validation_method = "DNS"

  tags = {
     Owner       = "user"
     Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "sre-assignment" {
  zone_id = data.aws_route53_zone.sre.zone_id
  name    = "wordpress.sre-assignment.click"
  type    = "CNAME"
  ttl     = "60"
  records = [data.aws_elb.elb_http.dns_name]
}




resource "aws_apigatewayv2_domain_name" "http_api" {
  domain_name = "api.sre-assignment.click"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.cert.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "http_api" {
  name    = aws_apigatewayv2_domain_name.http_api.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.sre.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.http_api.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.http_api.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_apigatewayv2_api_mapping" "http_api" {
  api_id      = aws_apigatewayv2_api.http_api.id
  domain_name = aws_apigatewayv2_domain_name.http_api.id
  stage       = local.route_key
}