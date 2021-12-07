
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}


module "vpc-public-private" {
  source  = "./terraform-aws-vpc-public-private"

}