locals {
  cluster_name       = "fiap-lanchonete-eks"
  iam_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  node_iam_role_name = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EMR_EC2_DefaultRole"
}

data "aws_caller_identity" "current" {}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [module.vpc_endpoints.vpc_id]
  }

  tags = {
    Tier = "Private"
  }

  depends_on = [module.vpc]
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [module.vpc_endpoints.vpc_id]
  }

  tags = {
    Tier = "Public"
  }

  depends_on = [module.vpc]
}


module "vpc" {
  source = "./modules/vpc"
}
module "vpc_endpoints" {
  source = "./modules/vpc-endpoints"
}
module "eks" {
  source = "./modules/eks"

  cluster_name      = local.cluster_name
  iam_role_arn      = local.iam_role_arn
  private_subnets   = data.aws_subnets.private
  public_subnets    = data.aws_subnets.public
  security_group_id = module.vpc_endpoints.security_group_id
  vpc_id            = module.vpc_endpoints.vpc_id

  depends_on = [module.vpc]
}

module "workers_node_group" {
  source = "./modules/nodes"

  private_subnets = module.vpc.private_subnets
  cluster_name    = local.cluster_name
  iam_role_arn    = local.iam_role_arn

  depends_on = [module.eks]
}




