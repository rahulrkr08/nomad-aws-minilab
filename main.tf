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

module "zf-vpc" {
  source = "./modules/vpc"
  vpc_id = var.aws_vpc_id
}
