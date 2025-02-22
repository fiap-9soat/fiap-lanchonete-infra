terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# resource "aws_instance" "app_server" {
#   ami           = "ami-830c94e3"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "fiap-lanchonete-server"
#   }
# }

resource "github_repository" "fiap-lanchonete" {
  name       = "fiap-lanchonete"
  visibility = "public"
}

resource "github_branch_protection" "lanchonete-master" {
  repository_id = github_repository.fiap-lanchonete.name

  pattern          = "master"
  enforce_admins   = true
  allows_deletions = true

  required_status_checks {
    strict = false
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = false
    restrict_dismissals             = false
    required_approving_review_count = 1
  }
}
