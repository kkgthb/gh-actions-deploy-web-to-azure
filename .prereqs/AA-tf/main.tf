module "azure_nonprod" {
  source = "./modules/azure"
  providers = {
    azurerm = azurerm.demo_nonprod_az_subscription
  }
  entra_tenant_id   = var.entra_tenant_id
  az_sub_id         = var.az_sub_id
  workload_nickname = "${var.workload_nickname}-nonprod"
}

module "azure_prod" {
  source = "./modules/azure"
  providers = {
    azurerm = azurerm.demo_prod_az_subscription
  }
  entra_tenant_id   = var.entra_tenant_id
  az_sub_id         = var.az_sub_id
  workload_nickname = "${var.workload_nickname}-prod"
}

module "entra_appreg" {
  source = "./modules/entra_appreg"
  providers = {
    azuread = azuread.demo
  }
  entra_tenant_id = var.entra_tenant_id
}

module "github" {
  source = "./modules/github"
  providers = {
    github = github.demo
  }
  entra_tenant_id             = var.entra_tenant_id
  pizza_app_nonprod_az_sub_id = module.azure_nonprod.subscription_id
  pizza_app_prod_az_sub_id    = module.azure_prod.subscription_id
  current_gh_repo_name        = var.current_gh_repo_name
}
