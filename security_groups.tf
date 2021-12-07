// Security group for ec2 instances

module "instance_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = local.service_rg_name
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.aws_vpc.private-public.id
  
  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp",
      cidr_blocks = "0.0.0.0/0"
    }

  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}


// Security group for RDS Database

module "instance_sg_rds" {
  depends_on = [
    module.instance_sg
  ]
  #* EFS Security Group
  
  source = "terraform-aws-modules/security-group/aws"

  name        = local.db_rg_name
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.aws_vpc.private-public.id

  number_of_computed_ingress_with_source_security_group_id = 1
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.instance_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
