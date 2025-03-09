output "instance_ip_addr" {
  value = module.eks.teste
}

output "shared_vpc_id" {
  value = module.vpc.vpc_id
}