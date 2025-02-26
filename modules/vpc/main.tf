provider "aws" {
  region = "us-east-1"
}

# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  #   source  = "../../"
  version = "5.8.1"

  name = "fiap-lanchonete-vpc"

  cidr = var.vpc_cidr
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = [var.private_subnet_1, var.private_subnet_2]
  public_subnets  = [var.public_subnet_1, var.public_subnet_2]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  #   public_subnet_tags = {
  #     "kubernetes.io/role/elb" = 1
  #   }

  #   private_subnet_tags = {
  #     "kubernetes.io/role/internal-elb" = 1
  #   }
}


################################################################################
# VPC Endpoints Module
################################################################################
