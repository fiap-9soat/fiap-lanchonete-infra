variable "aws_region" {
  type        = string
  description = "The region in which the resources will be created"
  default     = "us-east-1"
}

variable "access_key" {
  type        = string
  description = "The aws development account access key"
}

variable "secret_key" {
  type        = string
  description = "The aws development account secret key"
}

variable "token_key" {
  type        = string
  description = "The aws development account token (optional)"
  default     = ""
}

# variable "hcp_org_name" {
#   description = "The HCP organization name"
#   type        = string
#   default     = "fiap-lanchonete"
# }

# variable "hcp_workspace_name" {
#   description = "The HCP workspace name"
#   type        = string
#   default     = "lanchonete-infra"
# }

# variable "hcp_token" {
#     description = "The HCP Token that allows synchronization to the backend"
#     type = string
# }

