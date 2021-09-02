data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "subnet_ids" { 
  vpc_id = "${var.vpc_id}"
}

data "aws_subnet" "main" {
  for_each = data.aws_subnet_ids.subnet_ids.ids
  id       = each.value
}