data "aws_ami" "amznLinux" {
  most_recent = true
  owners      = ["amazon"]

  dynamic "filter" {
    for_each = var.ami_filters
    content {
      name   = filter.value["name"]
      values = filter.value["values"]
    }
  }
}

data "aws_key_pair" "key_pair" {
  key_name = "kennim-nclouds"
}

data "aws_iam_instance_profile" "s3_access_role"{
  name = "s3-access-role"
}