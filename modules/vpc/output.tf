output "vpc_id" {
  value = "${data.aws_vpc.selected.id}"
}

output "subnets" { 
  value = "${data.aws_subnet.main}"
}

output "security_groups" { 
  value = [aws_security_group.nomad-sg.id]
}