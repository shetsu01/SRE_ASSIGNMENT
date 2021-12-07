module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = local.identifier

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine               = local.engine
  engine_version       = local.engine_version
  family               = local.family
  major_engine_version = local.major_engine_version     # DB option group
  instance_class       =  local.instance_class

  allocated_storage     = local.allocated_storage
  max_allocated_storage = local.max_allocated_storage
  storage_encrypted     = local.storage_encrypted

  name     = local.db_name
  username = local.username
  password = local.password
  port     = local.port

  multi_az               = local.multi_az
  subnet_ids             = data.aws_subnet_ids.private.ids
  vpc_security_group_ids = [module.instance_sg_rds.security_group_id]

  maintenance_window              = local.maintenance_window
  backup_window                   = local.backup_window
  enabled_cloudwatch_logs_exports = ["general"]

  backup_retention_period = local.backup_retention_period
  skip_final_snapshot     = local.skip_final_snapshot
  deletion_protection     = local.deletion_protection

 
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
  db_instance_tags = {
    "Sensitive" = "high"
  }
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}



