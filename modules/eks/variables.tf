variable "cluster_name" {
  type        = string
  description = "Nome do cluster EKS a ser criado"
}

variable "iam_role_arn" {
  type        = string
  description = "ARN da role a ser utilizada para criar o cluster"
}

variable "private_subnets" {
  type = list(string)
  description = "IDs dos subnets privados"
}

variable "public_subnets" {
  type = list(string)
  description = "IDs dos subnets publicos"
}

variable "sg_id" {
  description = "ID do aws_security_group do EKS"
  type        = string
}
