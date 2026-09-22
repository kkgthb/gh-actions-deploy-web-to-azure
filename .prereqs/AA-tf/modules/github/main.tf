data "github_user" "current_gh_logged_in_user" {
  username = ""
}

data "github_repository" "current_gh_repo" {
  name = var.current_gh_repo_name
  lifecycle {
    postcondition {
      condition     = (coalesce(self.name, "") == var.current_gh_repo_name)
      error_message = "GitHub current repo name is not as passed in."
    }
  }
}

resource "github_repository_environment" "pizza_app_az_nonprod" {
  repository  = data.github_repository.current_gh_repo.full_name
  environment = "env-pizza-app-az-nonprod"
  # Business decision:  no review needed for workflow runs targeting "pizza" nonprod, so "reviewers" property skipped deliberately.
}

resource "github_repository_environment_deployment_policy" "pizza_app_az_nonprod_only_from_main" {
  repository  = github_repository_environment.pizza_app_az_nonprod.repository
  environment = github_repository_environment.pizza_app_az_nonprod.environment
  # Business decision:  workflow runs targeting "pizza" nonprod must be running from main.
  branch_pattern = "main"
}

resource "github_actions_environment_secret" "pizza_app_az_nonprod_entra_tenant_id" {
  repository  = github_repository_environment.pizza_app_az_nonprod.repository
  environment = github_repository_environment.pizza_app_az_nonprod.environment
  secret_name = "ENTRA_TENANT_ID"
  # Business note:  yes, same Entra tenant for pizza nonprod & prod.
  value = var.entra_tenant_id
}

# resource "github_actions_environment_secret" "pizza_app_az_nonprod_entra_client_id" {
#   repository  = github_repository_environment.pizza_app_az_nonprod.repository
#   environment = github_repository_environment.pizza_app_az_nonprod.environment
#   secret_name = "ENTRA_CLIENT_ID" # TODO:  defer to round 2
#   value       = "example-value"
# }

resource "github_actions_environment_secret" "pizza_app_az_nonprod_azure_subscription_id" {
  repository  = github_repository_environment.pizza_app_az_nonprod.repository
  environment = github_repository_environment.pizza_app_az_nonprod.environment
  secret_name = "AZURE_SUBSCRIPTION_ID"
  value       = var.pizza_app_nonprod_az_sub_id
}

resource "github_repository_environment" "pizza_app_az_prod" {
  repository  = data.github_repository.current_gh_repo.full_name
  environment = "env-pizza-app-az-prod"
  # Business decision:  review needed for workflow runs targeting "pizza" prod.  Business decision:  people may self-review their own workflow runs.
  prevent_self_review = false
  reviewers {
    users = [data.github_user.current_gh_logged_in_user.id]
  }
}

resource "github_repository_environment_deployment_policy" "pizza_app_az_prod_only_from_main" {
  repository  = github_repository_environment.pizza_app_az_prod.repository
  environment = github_repository_environment.pizza_app_az_prod.environment
  # Business decision:  workflow runs targeting "pizza" prod must be running from main.
  branch_pattern = "main"
}

resource "github_actions_environment_secret" "pizza_app_az_prod_entra_tenant_id" {
  repository  = github_repository_environment.pizza_app_az_prod.repository
  environment = github_repository_environment.pizza_app_az_prod.environment
  secret_name = "ENTRA_TENANT_ID"
  # Business note:  yes, same Entra tenant for pizza nonprod & prod.
  value = var.entra_tenant_id
}

# resource "github_actions_environment_secret" "pizza_app_az_prod_entra_client_id" {
#   repository  = github_repository_environment.pizza_app_az_prod.repository
#   environment = github_repository_environment.pizza_app_az_prod.environment
#   secret_name = "ENTRA_CLIENT_ID" # TODO:  defer to round 2
#   value       = "example-value"
# }

resource "github_actions_environment_secret" "pizza_app_az_prod_azure_subscription_id" {
  repository  = github_repository_environment.pizza_app_az_prod.repository
  environment = github_repository_environment.pizza_app_az_prod.environment
  secret_name = "AZURE_SUBSCRIPTION_ID"
  value       = var.pizza_app_prod_az_sub_id
}
