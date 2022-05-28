output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pv_subnets_list" {
  value = aws_subnet.private_subnets
}