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
    token = "O1YETTFMzzPD7g.atlasv1.M8jhTRaawZaNQ6LuUlAhP8UiznuMRE6zAGjHPtRkzuNZjoqmyTF8uetCXB4rzcYRhWM"
  }

  required_version = ">= 1.2.0"
}
