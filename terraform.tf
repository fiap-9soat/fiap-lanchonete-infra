terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
  }

  cloud {
    organization = "fiap-lanchonete"
    workspaces {
      tags = ["lanchonete-infra"]
    }
  }

  required_version = ">= 1.2.0"
}
