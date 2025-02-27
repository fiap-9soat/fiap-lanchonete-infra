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

locals {
  name = basename(path.cwd)

  region = "us-east-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    Example    = local.name
    GithubRepo = "fiap-lanchonete-infra"
    GithubOrg  = "fiap-9soat"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  #   source  = "../../"
  version = "5.8.1"

  name = local.name
  cidr = local.vpc_cidr
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  enable_nat_gateway           = true
  single_nat_gateway           = true
  enable_dns_hostnames         = true
  enable_dns_support           = true
  create_database_subnet_group = false

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
module "vpc_endpoints" {
  source = "../vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  create_security_group      = true
  security_group_name_prefix = "${local.name}-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }


  endpoints = {
    # mysql = {
    #   service         = "mysql"
    #   service_type    = "Gateway"
    #   route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
    #   #   policy          = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
    #   tags = { Name = "mysql-vpc-endpoint" }
    # },
    eks = {
      service             = "eks"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    rds = {
      service             = "rds"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [aws_security_group.rds.id]
    },
  }

  tags = merge(local.tags, {
    Project  = "Secret"
    Endpoint = "true"
  })
}

module "vpc_endpoints_nocreate" {
  source = "../vpc-endpoints"

  create = false
}

resource "aws_security_group" "rds" {
  name_prefix = "${local.name}-rds"
  description = "Allow MySQL inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = local.tags
}
