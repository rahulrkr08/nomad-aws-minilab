variable "env" {
  default = "dev"
}

variable "aws_vpc_id" {
  description = "Amazon VPC ID"
}

variable "aws_access_key" {
	description = "Access key for AWS account"
}

variable "aws_secret_key" {
	description = "Secret for AWS account"
}

variable "aws_region" {
	description = "The region name to deploy into"
}