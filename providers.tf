provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_token_key
}

provider "kubernetes" {
  host = module.eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_cluster_ca_certificate)
  token = module.eks.eks_cluster_token
}

provider "helm" {
  kubernetes {
    host = module.eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_cluster_ca_certificate)
    token = module.eks.eks_cluster_token
  }
}
