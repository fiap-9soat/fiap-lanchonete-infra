output "cluster_name" {
  description = "Name of the cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "teste" {
  value = local.private_subnets
}
