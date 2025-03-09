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
    organization = var.hcp_org_name
    workspaces {
      tags = [var.hcp_workspace_name]
    }
    token = var.hcp_token
  }

  required_version = ">= 1.2.0"
}
