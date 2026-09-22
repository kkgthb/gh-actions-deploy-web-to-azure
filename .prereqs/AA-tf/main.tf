module "nonprod_env_config" {
  source = "./modules/per_environment_config"
  providers = {
    azuread = azuread.demo
    azurerm = azurerm.demo_nonprod_az_subscription
    github  = github.demo
    random  = random.demo
  }
  entra_tenant_id                  = var.entra_tenant_id
  expected_az_sub_id               = var.az_sub_id_nonprod
  workload_nickname                = var.workload_nickname
  environment_nickname             = "nonprod"
  current_gh_repo_name             = var.current_gh_repo_name
  current_gh_repo_numeric_id       = var.current_gh_repo_numeric_id
  current_gh_repo_owner_login      = var.current_gh_repo_owner_login
  current_gh_repo_owner_numeric_id = var.current_gh_repo_owner_numeric_id
}

module "prod_env_config" {
  source = "./modules/per_environment_config"
  providers = {
    azuread = azuread.demo
    azurerm = azurerm.demo_prod_az_subscription
    github  = github.demo
    random  = random.demo
  }
  entra_tenant_id                  = var.entra_tenant_id
  expected_az_sub_id               = var.az_sub_id_prod
  workload_nickname                = var.workload_nickname
  environment_nickname             = "prod"
  current_gh_repo_name             = var.current_gh_repo_name
  current_gh_repo_numeric_id       = var.current_gh_repo_numeric_id
  current_gh_repo_owner_login      = var.current_gh_repo_owner_login
  current_gh_repo_owner_numeric_id = var.current_gh_repo_owner_numeric_id
}
