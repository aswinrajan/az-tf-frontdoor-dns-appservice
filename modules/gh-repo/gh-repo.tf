resource "github_repository" "portfolio-app-repo" {
  name        = "az-${var.prefix}-app"
  visibility = "public"
 
}

resource "github_repository_environment" "repo_environment" {
  repository       = github_repository.portfolio-app-repo.name
  environment      = "prod"
}

