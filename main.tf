module "vpc" {
  source = "./modules/vpc"
}
module "eks" {
  source     = "./modules/eks"
  depends_on = [module.vpc]
}
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





