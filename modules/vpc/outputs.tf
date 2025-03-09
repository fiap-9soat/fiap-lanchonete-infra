output "private_subnets" {
  description = "Private subnets ids"
  value       = local.private_subnets
}

output "public_subnets" {
  description = "Public subnets ids"
  value       = local.public_subnets
}
