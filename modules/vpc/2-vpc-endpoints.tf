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
    eks = {
      service             = "eks"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids = [aws_security_group.eks.id]
    },
  }

  tags = merge(local.tags, {
    Project  = "Secret"
    Endpoint = "true"
  },
    { "Subnet0" = module.vpc.private_subnets[0] },
    { "Subnet1" = module.vpc.private_subnets[1] },
    { "Subnet2" = module.vpc.private_subnets[2] },
    { "SecurityGroupId" = aws_security_group.eks.id },
  )
}
