module "azure" {
  source = "./modules/azure"
  providers = {
    azurerm = azurerm.demo
  }
  entra_tenant_id   = var.entra_tenant_id
  az_sub_id         = var.az_sub_id
  workload_nickname = var.workload_nickname
}

module "github" {
  source = "./modules/github"
  providers = {
    github = github.demo
  }
  current_gh_repo_name = var.current_gh_repo_name
}
