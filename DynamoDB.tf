module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = local.dynamodb_name
  hash_key = local.hash_key
  billing_mode   = local.billing_mode
  read_capacity  = 1
  write_capacity = 1

  autoscaling_read = {
    scale_in_cooldown  = 50
    scale_out_cooldown = 40
    target_value       = 45
    max_capacity       = 10
  }

  autoscaling_write = {
    scale_in_cooldown  = 50
    scale_out_cooldown = 40
    target_value       = 45
    max_capacity       = 10
  }

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "test"
    Project     = "sre"
  }
}

