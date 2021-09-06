provider "aws" {
  profile         = "default"
  access_key      = var.aws_access_key
  secret_key      = var.aws_secret_key
  region          = var.aws_region

  default_tags {
    tags = merge(
      var.additional_tags,
      {}
    )
  }
}

terraform {
  backend "remote" {
    organization = "Avaazz"

    workspaces {
      name = "zipslr-dev"
    }
  }
}

module "vpc" {
  source                    = "./modules/vpc"

  project                   = var.project
  env                       = var.env
  allowed_ip_network        = var.allowed_ip_network
  az_map                    = var.az_map
  aws_region                = var.aws_region
  additional_tags           = merge(
    var.additional_tags,
    {
      Name      =  "${var.project}-${var.env}"
    }
  )
}

module "nomad-cluster" {
  source                    = "./modules/nomad-cluster"

  project                   = var.project
  env                       = var.env
  security_groups           = module.vpc.security_groups
  subnets                   = module.vpc.subnets
  nomad_node_ami_id         = var.nomad_node_ami_id
  nomad_node_instance_size  = var.nomad_node_instance_size
  nomad_node_spot_price     = var.nomad_node_spot_price
  aws_key_name              = var.aws_key_name
  nomad_node_count          = var.nomad_node_count
  additional_tags           = merge(
    var.additional_tags,
    {
      Name      =  "${var.project}-${var.env}"
    }
  )
}
