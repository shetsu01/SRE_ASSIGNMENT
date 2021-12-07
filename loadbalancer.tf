module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = "Wordpress-elb"

  subnets         = data.aws_subnet_ids.public.ids
  security_groups = [module.instance_sg.security_group_id]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = 80
      instance_protocol = "http"
      lb_port           = 443
      lb_protocol       = "https"
      ssl_certificate_id = aws_acm_certificate.cert.arn
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 300
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 60
  }
  

}