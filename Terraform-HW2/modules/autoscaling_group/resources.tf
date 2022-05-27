module "launch_configuration" {
  source = "../lc_module"
}



resource "aws_autoscaling_group" "kmTFasg" {
  name                = "kmTFasg"
  max_size            = 2
  min_size            = 1
  desired_capacity    = 2
  vpc_zone_identifier = module.launch_configuration.private_subnets_ids_list
  launch_configuration = module.launch_configuration.lc_name
}

resource "aws_lb" "kmTFlb" {
  name               = "kmTFlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = module.launch_configuration.private_subnets_ids_list
}

resource "aws_lb_target_group" "kmTFlbtg" {
  name = "kmTFlbtg"
  port = 80
  protocol = "TCP"
  vpc_id = module.launch_configuration.sg_vpc_id
}

resource "aws_autoscaling_attachment" "kmTFasgattch" {
  autoscaling_group_name = aws_autoscaling_group.kmTFasg.id
  lb_target_group_arn   = aws_lb_target_group.kmTFlbtg.arn
}

resource "aws_lb_listener" "kmTFlblistener" {
  load_balancer_arn = aws_lb.kmTFlb.arn
  port = "80"
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.kmTFlbtg.arn
  }
}