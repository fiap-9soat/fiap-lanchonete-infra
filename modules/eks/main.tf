module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.31"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = local.iam_role_arn
    }
    kube-proxy = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = try(module.vpc_endpoints.endpoints["eks"].vpc_id, null)
  subnet_ids = try(module.vpc_endpoints.endpoints["eks"].subnet_ids, var.fallback)

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}

module "vpc_endpoints" {
  source = "../vpc-endpoints"
}

locals {
  cluster_name = "fiap-lanchonete-eks"
  iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
}

data "aws_caller_identity" "current" {}

variable "fallback" {
  type    = list(string)
  default = ["fallback1", "fallback2"]
}
