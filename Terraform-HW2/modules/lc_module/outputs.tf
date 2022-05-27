output "lc_name" {
  value = aws_launch_configuration.kmTFlc.name
}

output "sg_lb_id" {
  value = module.security_groups.lb_sg_id
}

output "sg_vpc_id" {
  value = module.security_groups.vpc__id
}

output "private_subnets_ids_list" {
  value = module.security_groups.vpc_pv_subnets_ids_list
}