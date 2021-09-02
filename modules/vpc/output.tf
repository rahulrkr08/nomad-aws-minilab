output "vpc_id" {
  value = "${data.aws_vpc.selected.id}"
}

output "subnets" { 
  value = "${data.aws_subnet.main}"
}