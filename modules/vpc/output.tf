output "vpc_id" {
  value = aws_vpc.nomad-lab-vpc.id
}

output "subnets" { 
  value = [for s in aws_subnet.nomad-lab-pub: s.id]
}

output "security_groups" { 
  value = [aws_security_group.nomad-sg.id]
}