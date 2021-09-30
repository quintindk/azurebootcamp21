terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.15.1"
    }
  }
}

# Configure the GitHub Provider
provider "github" {}

locals {
  reponame = "quintindk/azurebootcamp21"
}

data "github_repository" "repo" {
  full_name = local.reponame
}

resource "github_repository_environment" "repo_environment" {
  repository       = data.github_repository.repo.full_name
  environment      = var.environment
}

resource "github_actions_environment_secret" "arm_client_id_secret" {
  repository       = data.github_repository.repo.full_name
  environment      = github_repository_environment.repo_environment.environment
  secret_name      = "ARM_CLIENT_ID"
  plaintext_value  = var.client_id
}

resource "github_actions_environment_secret" "arm_client_secret_secret" {
  repository       = data.github_repository.repo.full_name
  environment      = github_repository_environment.repo_environment.environment
  secret_name      = "ARM_CLIENT_SECRET"
  plaintext_value  = var.client_secret
}

resource "github_actions_environment_secret" "arm_subscription_id_secret" {
  repository       = data.github_repository.repo.full_name
  environment      = github_repository_environment.repo_environment.environment
  secret_name      = "ARM_SUBSCRIPTION_ID"
  plaintext_value  = var.subscription_id
}

resource "github_actions_environment_secret" "arm_tenant_id_secret" {
  repository       = data.github_repository.repo.full_name
  environment      = github_repository_environment.repo_environment.environment
  secret_name      = "ARM_TENANT_ID"
  plaintext_value  = var.tenant_id
}
