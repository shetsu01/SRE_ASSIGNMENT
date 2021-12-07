

module "auto_scaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "${var.vpc_name}auto_scaling"

  # Launch configuration
  lc_name = "${var.vpc_name}auto_scaling_lc"

  image_id        = data.aws_ami.amazon-linux-2.id
  instance_type   = var.instance_type
  security_groups = [module.instance_sg.security_group_id]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "8"
      delete_on_termination = true
    },
  ]


  # Auto scaling group
  asg_name                  = "${var.vpc_name}auto_scaling_lc"
  vpc_zone_identifier       = data.aws_subnet_ids.public.ids
  health_check_type         = "EC2"
  min_size                  = 2
  max_size                  = 3
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  user_data                 = data.template_file.init.rendered
  key_name                  = aws_key_pair.ec2key.key_name

  tags = [
    {
      key                 = "Environment"
      value               = "Dev"
      propagate_at_launch = true
    }
  ]

}




resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = module.auto_scaling.this_autoscaling_group_id
  elb                    = module.elb_http.this_elb_id
}

