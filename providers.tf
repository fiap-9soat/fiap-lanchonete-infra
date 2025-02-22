provider "github" {
  token = var.github_pat
  owner = "fiap-9soat"
}

provider "aws" {
  region = "us-east-1"
}
