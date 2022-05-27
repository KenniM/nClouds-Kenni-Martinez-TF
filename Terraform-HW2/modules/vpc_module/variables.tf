variable "main_cidr_block" {
  description = "A /16 CIDR range, used to create the VPC"
  default     = "150.10.0.0/16"
}

variable "availability_zones_list" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
