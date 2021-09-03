variable "env" {}

variable "nomad_node_ami_id" {
	description = "AMI ID to use for Nomad nodes"
}

variable "nomad_node_instance_size" {
	description = "EC2 instance type/size for Nomad nodes"
}

variable "nomad_node_spot_price" {
	description = "Price for spot instance"
}

variable "aws_key_name" {
	description = "SSH key name"
}

variable "nomad_node_count" {
  description = "The number of server nodes (should be 3 or 5)"
  type        = number
}

variable "security_groups" { }

variable "subnets" { }
