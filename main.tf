locals {
  cluster_name = "fiap-lanchonete-eks"
  iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
}

data "aws_caller_identity" "current" {}


module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = local.cluster_name
  iam_role_arn    = local.iam_role_arn
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  sg_id           = module.vpc.eks_sg_id

  depends_on = [module.vpc]
}

module "workers_node_group" {
  source = "./modules/nodes"

  cluster_name    = local.cluster_name
  iam_role_arn    = local.iam_role_arn
  private_subnets = module.vpc.private_subnets

  depends_on = [module.vpc, module.eks]
}

# module "kube" {
#   source               = "./modules/kube"
#   mercado_pago_api_key = var.mercado_pago_api_key
#   mysql_url            = var.db_url
#   mysql_password       = var.db_password
#   mysql_username       = var.db_username
#   cluster_name         = module.eks.eks_cluster_name
#   vpc_id               = module.vpc.vpc_id
#   aws_region           = var.aws_region

#   depends_on = [module.eks]
# }

module "api_gateway" {
  source = "./modules/api_gateway"

  aws_region     = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_token_key  = var.aws_token_key

  #   depends_on = [module.kube]
}



