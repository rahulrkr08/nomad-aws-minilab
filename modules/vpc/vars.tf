variable "env" { }

variable "project" { }

variable "allowed_ip_network" {
	description = "Networks allowed in security group for ingress rules"
}

variable "aws_region" {
	description = "The region name to deploy into"
}

variable "az_map" { }

variable "additional_tags" { }