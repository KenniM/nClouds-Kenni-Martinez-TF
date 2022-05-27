module "vpc" {
  source = "../vpc_module"
}

resource "aws_security_group" "kmTFsg" {
  name        = "kmTFsg"
  description = "Security Group created for Launch Configuration"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.sg_inbound_rules
    content {
      from_port  = ingress.value["port"]
      to_port    = ingress.value["port"]
      protocol   = ingress.value["protocol"]
      cidr_blocks = [ingress.value["source"]]
      security_groups = [aws_security_group.kmTFlbsg.id]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups = [aws_security_group.kmTFlbsg.id]
  }

  tags = {
    "Name" = "kmTFsg"
  }
}

resource "aws_security_group" "kmTFlbsg" {
  name        = "kmTFlvsg"
  description = "Security Group created for Load Balancer used in Launch Configuration"
  vpc_id      = module.vpc.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "kmTFlvsg"
  }
}
