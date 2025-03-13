resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-managed-node-group"
  node_role_arn   = var.iam_role_arn

  subnet_ids = var.private_subnets

  ami_type             = "AL2_x86_64"
  capacity_type        = "SPOT"
  disk_size            = 20
  force_update_version = false

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  labels = {
    role = "nodes-${var.cluster_name}"
  }

}


