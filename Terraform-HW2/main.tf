terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.14.0"
    }
  }
}

locals {
  creationDateTime = formatdate("DD MMM YYYY - HH:mm AA ZZZ", timestamp())
}

# Choosing region
provider "aws" {
  region = "us-west-2"
}

module "autoscaling_group" {
  source = "./modules/autoscaling_group"
}
