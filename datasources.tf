
data "aws_route53_zone" "sre" {
  name         = "sre-assignment.click."
}

data "aws_elb" "elb_http" {
  depends_on = [
    module.elb_http
  ]
  name = "Wordpress-elb"
}

data "aws_vpc" "private-public" {
  depends_on = [
    module.vpc-public-private
  ]
  tags = {
   Name = "sre-vpc-public-private"

  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.private-public.id

  tags = {
    SubnetType = "private"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.private-public.id

  tags = {
    SubnetType = "public"
  }
}


data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners           = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}