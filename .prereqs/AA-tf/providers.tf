# Configure the AzureAD (Entra) Terraform provider
provider "azuread" {
  alias     = "demo"
  tenant_id = var.entra_tenant_id
}
# Configure the AzureRM Terraform provider for "nonprod"
provider "azurerm" {
  features {}
  alias                           = "demo_nonprod_az_subscription"
  tenant_id                       = var.entra_tenant_id
  subscription_id                 = var.az_sub_id_nonprod
  resource_provider_registrations = "none"
}
# Configure the AzureRM Terraform provider for "prod"
provider "azurerm" {
  features {}
  alias                           = "demo_prod_az_subscription"
  tenant_id                       = var.entra_tenant_id
  subscription_id                 = var.az_sub_id_prod
  resource_provider_registrations = "none"
}
# Configure the GitHub Terraform provider
provider "github" {
  alias = "demo"
}
# Configure the Random" Terraform provider
provider "random" {
  alias = "demo"
}
