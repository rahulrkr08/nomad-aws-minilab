variable "env" {
  default = "dev"
}

variable "project" { }

variable "aws_access_key" {
	description = "Access key for AWS account"
}

variable "aws_secret_key" {
	description = "Secret for AWS account"
}

variable "aws_region" {
	description = "The region name to deploy into"
}

variable "allowed_ip_network" {
	description = "Networks allowed in security group for ingress rules"
}

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

variable "az_map" {
	type = map

	default = {
		0 = "a"
		1 = "b"
		2 = "c"
	}
}

variable "additional_tags" {
  default     = {
    Terraform 		= "true"
    Avaazz 			= "true"
  }

  description 		= "Additional resource tags"
  type        		= map(string)
}