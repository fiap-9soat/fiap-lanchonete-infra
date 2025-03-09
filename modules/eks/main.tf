resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.iam_role_arn

  vpc_config {
    endpoint_private_access   = false
    endpoint_public_access    = true
    cluster_security_group_id = var.security_group_id
    vpc_id                    = var.vpc_id

    subnet_ids = concat(local.private_subnets, local.public_subnets)
  }
}

locals {
  private_subnets = tolist([for i in range(0, 3) : tostring({ for key, value in var.private_subnets : key => value }["${i}"])])
  public_subnets  = tolist([for i in range(0, 3) : tostring({ for key, value in var.public_subnets : key => value }["${i}"])])
}

