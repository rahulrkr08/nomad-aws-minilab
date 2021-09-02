# resource "aws_instance" "nomad-node" {
#     count = var.nomad_node_count
#     ami = var.nomad_node_ami_id
#     instance_type = var.nomad_node_instance_size
#     key_name = var.aws_key_name
#     subnet_id = aws_subnet.nomad-lab-pub[count.index].id
#     vpc_security_group_ids = [aws_security_group.nomad-sg.id]
#     associate_public_ip_address = true
#     user_data = file("conf/install-nomad.sh")
#     private_ip = "10.0.${count.index}.100"

#     tags = {
#         Terraform = "true"
#         ProvisionedBy = "Project Avaazz"
#         Avaazz = "true"
#         Name = "nomad-node-${count.index}"
#     }
# }

resource "aws_launch_template" "nomad-node" {
  name                        = "launch-template"
  image_id                    = var.nomad_node_ami_id
  instance_type               = var.nomad_node_instance_size
  key_name                    = var.aws_key_name
  subnet_id                   = aws_subnet.nomad-lab-pub[count.index].id
  vpc_security_group_ids      = [aws_security_group.nomad-sg.id]
  associate_public_ip_address = true
  user_data                   = file("conf/install-nomad.sh")
  private_ip_address          = "10.0.${count.index}.100"

  tags = {
    Terraform = "true"
    ProvisionedBy = "Project Avaazz"
    Avaazz = "true"
    Name = "nomad-node-${count.index}"
  }
}

resource "aws_spot_fleet_request" "nomad-node" {
  iam_fleet_role  = "arn:aws:iam::242548965055:role/aws-ec2-spot-fleet-autoscale-role"
  spot_price      = var.nomad_node_spot_price
  target_capacity = 3

  launch_template_config {
    launch_template_specification {
      id      = aws_launch_template.nomad-node.id
      version = aws_launch_template.nomad-node.latest_version
    }
  }

  # depends_on = [aws_iam_policy_attachment.test-attach]
}
