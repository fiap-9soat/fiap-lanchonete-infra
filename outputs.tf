output "eks_nodegroup_id" {
  value = module.workers_node_group.eks_nodegroup_id
}

output "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_id" {
  description = "ID of the EKS Cluster"
  value       = module.eks.eks_cluster_id
}

output "shared_vpc_id" {
  value = module.vpc.vpc_id
}
