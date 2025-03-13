terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
  }

  cloud {
    organization = "fiap-lanchonete"
    workspaces {
      tags = ["lanchonete-infra"]
    }
  }

  required_version = ">= 1.11.0"
}
