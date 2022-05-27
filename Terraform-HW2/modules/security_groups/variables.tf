variable "sg_inbound_rules" {
  type = list(any)
  default = [
    {
      port     = 80
      protocol = "tcp"
      source   = "0.0.0.0/0"
    },
    {
      port     = 443
      protocol = "tcp"
      source   = "0.0.0.0/0"
    },
    {
      port     = 22
      protocol = "tcp"
      source   = "0.0.0.0/0"
    }
  ]
}
