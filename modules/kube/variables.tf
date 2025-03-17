variable "mysql_url" {
  type = string
}

variable "mysql_username" {
  sensitive = true
  type      = string
}

variable "mysql_password" {
  sensitive = true
  type      = string
}

variable "mercado_pago_api_key" {
  sensitive = true
  type      = string
}

variable "mercado_pago_id_loja" {
  sensitive = true
  type      = string
}

variable "mercado_pago_id_conta" {
  sensitive = true
  type      = string
}

variable "cluster_name" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
}
