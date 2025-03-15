variable "aws_region" {
  type        = string
  description = "The region in which the resources will be created"
  default     = "us-east-1"
}

variable "aws_access_key" {
  type        = string
  description = "The aws development account access key"
}

variable "aws_secret_key" {
  type        = string
  description = "The aws development account secret key"
}

variable "aws_token_key" {
  type        = string
  description = "The aws development account token (optional)"
  default     = ""
}

variable "db_url" {
  type        = string
  description = "The URL of the MySQL instance"
}

variable "db_username" {
  type        = string
  description = "Usuario do DB, deve ser o mesmo especificado na configuraçao do RDS"
}

variable "db_password" {
  type        = string
  description = "Senha do DB, deve ser o mesmo especificado na configuraçao do RDS"
}

variable "mercado_pago_api_key" {
  type        = string
  description = "API Key do MercadoPago"
  default     = "TESTE-"
}

