provider "github" {
  token = var.github_pat
  owner = "fiap-9soat"
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
}
