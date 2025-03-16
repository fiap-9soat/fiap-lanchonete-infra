################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = local.name
  cidr = local.vpc_cidr
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = local.private_subnet_names
  public_subnets  = local.public_subnet_names

  enable_nat_gateway           = true
  single_nat_gateway           = true
  enable_dns_hostnames         = true
  enable_dns_support           = true
  create_database_subnet_group = false

  tags = merge(local.tags, {
    Name = "fiap-lanchonete-vpc-1"
  })
}
