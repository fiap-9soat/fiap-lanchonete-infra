variable "private_subnets" {
  type = list(string)
  description = "Lista de IDs das subnets privadas"
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster referencia do EKS"
}
variable "iam_role_arn" {
  type        = string
  description = "ARN da role a ser utilizada para criar o NodeGroup"
}
