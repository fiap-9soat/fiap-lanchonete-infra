output "eks_cluster_name" {
  description = "Name of the cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_ca_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "eks_cluster_token" {
  value = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

