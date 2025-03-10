variable "private_subnets" {
  type = set(string)
}

variable "cluster_name" {
  type = string
}
variable "iam_role_arn" {
  type = string
}
