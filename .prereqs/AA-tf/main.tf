module "azure" {
  source = "./modules/azure"
  providers = {
    azurerm = azurerm.demo
  }
  entra_tenant_id   = var.entra_tenant_id
  az_sub_id         = var.az_sub_id
  workload_nickname = var.workload_nickname
}
