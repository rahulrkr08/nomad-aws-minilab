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
  count = length(data.aws_subnet_ids.subnet_ids.ids)

  subnet_id = sort(data.aws_subnet_ids.subnet_ids.ids)[count.index]
  route_table_id = aws_route_table.nomad-lab-public-crt.id

  lifecycle { 
      create_before_destroy = true 
  }

  depends_on = [
    aws_route_table.nomad-lab-public-crt,
  ]
}

