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

# variable "db_url" {
#   type        = string
#   description = "The URL of the MySQL instance"
#   default     = "mysql:3306"
# }

# variable "db_username" {
#   type        = string
#   description = "Usuario do DB, deve ser o mesmo especificado na configuraçao do RDS"
#   default     = "fiap"
# }

# variable "db_password" {
#   type        = string
#   description = "Senha do DB, deve ser o mesmo especificado na configuraçao do RDS"
#   default     = "fiap-lanchonete"
# }

# variable "mercado_pago_api_key" {
#   type        = string
#   description = "API Key do MercadoPago"
#   default     = "TEST-8402790990254628-112619-4290252fdac6fd07a3b8bb555578ff39-662144664"
# }
# variable "mercado_pago_id_loja" {
#   sensitive   = true
#   type        = string
#   description = "ID da Loja associada a conta do MP"
#   default     = "1B2D92F23"
# }

# variable "mercado_pago_id_conta" {
#   sensitive   = true
#   type        = number
#   description = "ID da Conta do MP"
#   default     = 662144664
# }

