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

output "security_group_id" {
  value = module.vpc.eks_sg_id
}

output "private_subnets_ids" {
  value = module.vpc.private_subnets
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "aws_region" {
  value = var.aws_region
}

output "api_gateway_endpoint" {
  value = module.api_gateway.api_endpoint
}