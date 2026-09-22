# ------------------------------------------------------------------------
# Validate logged-in state of Entra, GitHub, and Azure Terraform providers
# ------------------------------------------------------------------------

data "azuread_client_config" "current_azuread_config" {
  lifecycle {
    postcondition {
      condition     = (coalesce(self.client_id, "") == "04b07795-8ddb-461a-bbee-02f9e1bf7b46")
      error_message = "AzureAD login state client ID is not the well-known Azure CLI GUID."
    }
    postcondition {
      condition     = (coalesce(self.tenant_id, "") == var.entra_tenant_id)
      error_message = "AzureAD login state tenant ID is not as passed in."
    }
    postcondition {
      condition     = (coalesce(self.object_id, "") != "")
      error_message = "AzureAD login state does not bear a logged-in user object ID."
    }
  }
}

data "azurerm_client_config" "current_azurerm_config" {
  lifecycle {
    postcondition {
      condition     = (coalesce(self.client_id, "") == "04b07795-8ddb-461a-bbee-02f9e1bf7b46")
      error_message = "AzureRM login state client ID is not the well-known Azure CLI GUID."
    }
    postcondition {
      condition     = (coalesce(self.subscription_id, "") == var.expected_az_sub_id)
      error_message = "AzureRM login state subscription ID is not as passed in."
    }
    postcondition {
      condition     = (coalesce(self.object_id, "") != "")
      error_message = "AzureRM login state does not bear a logged-in user object ID."
    }
  }
}

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

# ------------------------------------------
# Entra App Registration & Service Principal
# ------------------------------------------

resource "azuread_application" "the_entra_appreg" {
  display_name = "GH-into-${var.workload_nickname}-${var.environment_nickname}"
  description  = "Gives GitHub Actions an Entra principal for logging into the ${var.environment_nickname} environment of the ${var.workload_nickname} workload."
  owners       = [data.azuread_client_config.current_azuread_config.object_id]
}

resource "azuread_service_principal" "the_entra_sp" {
  client_id   = azuread_application.the_entra_appreg.client_id
  description = "Gives GitHub Actions an Entra principal for logging into the ${var.environment_nickname} environment of the ${var.workload_nickname} workload."
  owners      = [data.azuread_client_config.current_azuread_config.object_id]
}

# ----------------------------------------
# GitHub Environment & Environment Secrets
# ----------------------------------------

resource "github_repository_environment" "the_gh_env" {
  repository  = data.github_repository.current_gh_repo.full_name
  environment = "${var.workload_nickname}-ghenv-${var.environment_nickname}"
  # Business note:  yes, same reviewer requirements for all environments, in this demo.
  prevent_self_review = false
  reviewers {
    users = [data.github_user.current_gh_logged_in_user.id]
  }
}

resource "github_actions_environment_secret" "gh_env_secret_entra_tenant_id" {
  repository  = github_repository_environment.the_gh_env.repository
  environment = github_repository_environment.the_gh_env.environment
  secret_name = "ENTRA_TENANT_ID"
  # Business note:  yes, same Entra tenant for all environments, in this demo.
  value = data.azuread_client_config.current_azuread_config.tenant_id
}

resource "github_actions_environment_secret" "gh_env_secret_entra_client_id" {
  repository  = github_repository_environment.the_gh_env.repository
  environment = github_repository_environment.the_gh_env.environment
  secret_name = "ENTRA_CLIENT_ID"
  value       = azuread_service_principal.the_entra_sp.client_id
}

resource "github_actions_environment_secret" "gh_env_secret_azure_subscription_id" {
  repository  = github_repository_environment.the_gh_env.repository
  environment = github_repository_environment.the_gh_env.environment
  secret_name = "AZURE_SUBSCRIPTION_ID"
  value       = data.azurerm_client_config.current_azurerm_config.subscription_id
}

# ------------------------------------------
# Entra App Registration & Service Principal
# ------------------------------------------

resource "azuread_application_federated_identity_credential" "the_entra_appreg_fedcred" {
  application_id = azuread_application.the_entra_appreg.id
  display_name   = "cicd-github"
  description    = "Allow GitHub Actions to become this Entra App Registration"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.current_gh_repo_owner_login}@${var.current_gh_repo_owner_numeric_id}/${var.current_gh_repo_name}@${var.current_gh_repo_numeric_id}:environment:${github_repository_environment.the_gh_env.environment}"
}

# ---------------
# Azure resources
# ---------------

resource "azurerm_resource_group" "my_resource_group" {
  name     = "${var.workload_nickname}-rg-demo"
  location = "centralus"
}

# TODO:  Azure Function App & the funcapp-scoped Azure RBAC Role Assignment of "Website Contributor" to `azuread_service_principal.the_entra_sp`
