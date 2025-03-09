output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnets ids"
  value       = local.private_subnets
}

output "public_subnets" {
  description = "Public subnets ids"
  value       = local.public_subnets
}
