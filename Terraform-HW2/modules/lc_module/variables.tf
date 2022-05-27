variable "ami_filters" {
  type = list(any)
  default = [
    {
      name   = "name"
      values = ["amzn2-ami-hvm-*-gp2"]
    },
    {
      name   = "root-device-type"
      values = ["ebs"]
    },
    {
      name   = "virtualization-type"
      values = ["hvm"]
    },
    {
      name   = "architecture"
      values = ["x86_64"]
    }
  ]
}