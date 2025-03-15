variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "mysql_username" {
  sensitive = true
  type = string
}

variable "mysql_password" {
  sensitive = true
  type = string
}

variable "mercado_pago_api_key" {
  sensitive = true
  type = string
}