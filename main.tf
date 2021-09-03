provider "aws" {
  profile    = "default"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

terraform {
  backend "remote" {
    organization = "Avaazz"

    workspaces {
      name = "nomad-aws-minilab"
    }
  }
}

module "vpc" {
  source                    = "./modules/vpc"
  vpc_id                    = var.aws_vpc_id
  allowed_ip_network        = var.allowed_ip_network
}

module "cluster" {
  source                    = "./modules/cluster"
  env                       = var.env
  security_groups           = module.vpc.security_groups
  subnets                   = module.vpc.subnets
  nomad_node_ami_id         = var.nomad_node_ami_id
  nomad_node_instance_size  = var.nomad_node_instance_size
  nomad_node_spot_price     = var.nomad_node_spot_price
  aws_key_name              = var.aws_key_name
  nomad_node_count          = var.nomad_node_count
}
