output "cluster_name" {
  description = "Name of the cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "teste" {
  value = aws_eks_cluster.eks_cluster.vpc_config[0].subnet_ids
}
