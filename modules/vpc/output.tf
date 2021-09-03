output "vpc_id" {
  value = aws_vpc.nomad-lab-vpc.id
}

output "subnets" { 
  value = [aws_subnet.nomad-lab-pub.*.ids]
}

output "security_groups" { 
  value = [aws_security_group.nomad-sg.id]
}