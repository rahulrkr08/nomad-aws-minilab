resource "aws_internet_gateway" "nomad-lab-igw" {
  vpc_id = aws_vpc.nomad-lab-vpc.id

  tags = merge(
    var.additional_tags,
    {}
  )
}

resource "aws_route_table" "nomad-lab-public-crt" {
  vpc_id = aws_vpc.nomad-lab-vpc.id
  
  route {
      cidr_block = "0.0.0.0/0" 
      gateway_id = aws_internet_gateway.nomad-lab-igw.id
  }
  
  tags = merge(
    var.additional_tags,
    {}
  )
}

resource "aws_route_table_association" "subnet_association" {
  count = length(aws_subnet.nomad-lab-pub)

  subnet_id = aws_subnet.nomad-lab-pub[count.index].id
  route_table_id = aws_route_table.nomad-lab-public-crt.id

  lifecycle { 
      create_before_destroy = true 
  }

  depends_on = [
    aws_route_table.nomad-lab-public-crt,
  ]
}

