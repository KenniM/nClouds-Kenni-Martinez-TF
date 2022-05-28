output "sg_id" {
  value = aws_security_group.kmTFsg.id
}

output "lb_sg_id" {
  value = aws_security_group.kmTFlbsg.id
}

output "vpc__id" {
  value = module.vpc.vpc_id
}

output "vpc_pv_subnets_list" {
  value = module.vpc.pv_subnets_list
}