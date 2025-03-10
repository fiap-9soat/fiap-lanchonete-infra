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

variable "hcp_org" {
  description = "The Terraform HCP organization name"
  type        = string
  default     = "fiap-lanchonete"
}

variable "hcp_workspace" {
  description = "The Terraform HCP organization's workspace name"
  type        = string
  default     = "lanchonete-infra-2"
}
