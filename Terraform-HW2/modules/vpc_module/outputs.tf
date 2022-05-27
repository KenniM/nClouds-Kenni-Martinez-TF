output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pv_subnet1_id" {
  value = aws_subnet.private1.id
}

output "pv_subnet2_id" {
  value = aws_subnet.private2.id
}

output "pv_subnet3_id" {
  value = aws_subnet.private3.id
}