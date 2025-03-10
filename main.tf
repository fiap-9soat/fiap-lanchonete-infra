locals {
  cluster_name       = "fiap-lanchonete-eks"
  iam_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  node_iam_role_name = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EMR_EC2_DefaultRole"
}

data "aws_caller_identity" "current" {}


module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = local.cluster_name
  iam_role_arn    = local.iam_role_arn
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  depends_on = [module.vpc]
}

module "workers_node_group" {
  source = "./modules/nodes"

  cluster_name    = local.cluster_name
  iam_role_arn    = local.iam_role_arn
  private_subnets = module.vpc.private_subnets

  depends_on = [module.vpc, module.eks]
}




