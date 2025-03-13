variable "cognito_user_pool_name" {
  description = "The Cognito user pool name, as defined in fiap-lanchonete-auth"
  type = string
  default = "fiap-user-pool"
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}