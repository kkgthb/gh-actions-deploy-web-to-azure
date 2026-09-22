# Configure the AzureRM Terraform provider for "nonprod"
provider "azurerm" {
  features {}
  alias                           = "demo_nonprod_az_subscription"
  tenant_id                       = var.entra_tenant_id
  subscription_id                 = var.az_sub_id # FYI, in a real enterprise situation, we would be working with two different subscription IDs, but I only have 1.
  resource_provider_registrations = "none"
}
# Configure the AzureRM Terraform provider for "prod"
provider "azurerm" {
  features {}
  alias                           = "demo_prod_az_subscription"
  tenant_id                       = var.entra_tenant_id
  subscription_id                 = var.az_sub_id # FYI, in a real enterprise situation, we would be working with two different subscription IDs, but I only have 1.
  resource_provider_registrations = "none"
}
# Configure the GitHub Terraform provider
provider "github" {
  alias = "demo"
}
