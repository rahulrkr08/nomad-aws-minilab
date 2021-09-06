resource "aws_vpc" "nomad-lab-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_classiclink = "false"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = merge(
    var.additional_tags,
    {}
  )
}

resource "aws_subnet" "nomad-lab-pub" {
	count = 3
  vpc_id = aws_vpc.nomad-lab-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.aws_region}${var.az_map[count.index]}"

  tags = merge(
    var.additional_tags,
    {}
  )
}
