variable "cognito_user_pool_name" {
  description = "The Cognito user pool name, as defined in fiap-lanchonete-auth"
  type        = string
  default     = "fiap-user-pool"
}

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

variable "create_vpc_link" {
  type        = bool
  description = "If a new VPC link should be created."
  default     = false
}
