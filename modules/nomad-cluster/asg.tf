# resource "aws_instance" "nomad-node" {
#   count = var.nomad_node_count
#   ami = var.nomad_node_ami_id
#   instance_type = var.nomad_node_instance_size
#   key_name = var.aws_key_name
#   subnet_id = var.subnets[count.index]
#   vpc_security_group_ids = var.security_groups
#   associate_public_ip_address = true
#   user_data = file("conf/install-nomad.sh")
#   private_ip = "10.0.${count.index}.100"

#   tags = merge(
#     var.additional_tags,
#     {}
#   )
# }

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

resource "aws_launch_configuration" "nomad-node-lc" {
  name_prefix                 = "nomad-launch-configuration-"
  image_id                    = var.nomad_node_ami_id
  instance_type               = var.nomad_node_instance_size
  spot_price                  = var.nomad_node_spot_price
  key_name                    = var.aws_key_name
  security_groups             = var.security_groups
  user_data                   = file("conf/install-nomad.sh")
  
  lifecycle {
    create_before_destroy = true
  }
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version                     = "~> 4.4.0"
  
  name                        = "nomad-node-asg"

  # Launch configuration
  create_lc                   = false
  use_lc                      = true
  launch_configuration        = aws_launch_configuration.nomad-node-lc.name
  iam_instance_profile_arn    = aws_iam_instance_profile.nomad-node-profile.id

  # Auto scaling group 
  vpc_zone_identifier         = [for s in var.subnets : s]
  health_check_type           = "EC2"
  min_size                    = 1
  max_size                    = var.nomad_node_count
  desired_capacity            = var.nomad_node_count
  wait_for_capacity_timeout   = 0

  network_interfaces = [
    {
      delete_on_termination = true
      device_index          = 0
      private_ip_address    = "10.0.0.100"
    },
    {
      delete_on_termination = true
      device_index          = 1
      private_ip_address    = "10.0.1.100"
    },
    {
      delete_on_termination = true
      device_index          = 2
      private_ip_address    = "10.0.2.100"
    }
  ]

  tags_as_map = merge(
    var.additional_tags,
    {}
  )
}