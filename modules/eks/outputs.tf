output "eks_cluster_name" {
  description = "Name of the cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}
