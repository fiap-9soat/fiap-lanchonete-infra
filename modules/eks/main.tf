locals {
  tags = {
    GithubRepo = "fiap-lanchonete-infra"
    GithubOrg  = "fiap-9soat"
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.iam_role_arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    security_group_ids = [var.sg_id]
    subnet_ids = concat(var.public_subnets, var.private_subnets)
  }

  tags = local.tags
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = aws_eks_cluster.eks_cluster.name

  depends_on = [aws_eks_cluster.eks_cluster]
}
