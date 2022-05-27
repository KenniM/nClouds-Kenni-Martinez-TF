terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.14.0"
    }
  }
}

# Choosing region
provider "aws" {
  region = "us-west-2"
}

/*module "vpc" {
  source = "./modules/vpc_module"  
}*/

module "autoscaling_group" {
  source = "./modules/autoscaling_group"
}
