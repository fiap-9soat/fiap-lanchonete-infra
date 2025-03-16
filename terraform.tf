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
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
  }

  required_version = ">= 1.11.0"
}
