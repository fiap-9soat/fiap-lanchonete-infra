module "vpc" {
  source = "./modules/vpc"
}
# module "eks" {
#   source     = "./modules/eks"
#   depends_on = [module.vpc]
# }






