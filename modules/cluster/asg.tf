data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "nomad-node-role" {
  name_prefix         = "nomad-node-role-"
  path                = "/ecs/"
  assume_role_policy  = data.aws_iam_policy_document.ecs-instance-policy.json
}

resource "aws_iam_instance_profile" "nomad-node-profile" {
  name_prefix = "nomad-node-profile-"
  role = aws_iam_role.nomad-node-role.name
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"
  
  name = "nomad-node-asg"

  # Launch configuration
  lc_name = "nomad-node-launch-configuration-"

  image_id                    = var.nomad_node_ami_id
  instance_type               = var.nomad_node_instance_size
  spot_price                  = var.nomad_node_spot_price
  security_groups             = var.security_groups
  user_data                   = file("conf/install-nomad.sh")
  key_name                    = var.aws_key_name
  iam_instance_profile        = aws_iam_instance_profile.nomad-node-profile.id

  # Auto scaling group
  asg_name                  = "nomad-node-autoscaling-group-"
  vpc_zone_identifier       = [for s in var.subnets : s.id]
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = var.nomad_node_count
  desired_capacity          = var.nomad_node_count
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = var.env
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "zipslr"
      propagate_at_launch = true
    },
  ]
}