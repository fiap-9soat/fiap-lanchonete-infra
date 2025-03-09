# output "teste1" {
#   value = toset(data.aws_subnets.private.ids)
# }

output "teste2" {
  value = module.eks.teste
}

output "vpc_id" {
  value = module.vpc_endpoints.vpc_id
}
