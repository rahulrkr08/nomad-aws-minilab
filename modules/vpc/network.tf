resource "aws_internet_gateway" "nomad-lab-igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "nomad-lab"
    Terraform = "true"
    Avaazz = "true"
  }
}

resource "aws_route_table" "nomad-lab-public-crt" {
  vpc_id = var.vpc_id
  
  route {
      cidr_block = "0.0.0.0/0" 
      gateway_id = aws_internet_gateway.nomad-lab-igw.id
  }
  
  tags = {
    Name = "nomad-lab"
    Terraform = "true"
    Avaazz = "true"
  }
}

resource "aws_route_table_association" "subnet_association" {
  count = 3

  subnet_id = data.aws_subnet.main[count.index].id
  route_table_id = aws_route_table.nomad-lab-public-crt.id

  lifecycle { 
      create_before_destroy = true 
  }

  depends_on = [
      aws_subnet.nomad-lab-pub,
      #data.aws_subnet_ids.nomad_subnets,
      aws_route_table.nomad-lab-public-crt,
  ]
}

