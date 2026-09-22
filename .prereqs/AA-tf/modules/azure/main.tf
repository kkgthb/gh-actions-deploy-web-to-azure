data "azurerm_client_config" "current_azurerm_config" {
  lifecycle {
    postcondition {
      condition     = (coalesce(self.client_id, "") == "04b07795-8ddb-461a-bbee-02f9e1bf7b46")
      error_message = "AzureRM login state client ID is not the well-known Azure CLI GUID."
    }
    postcondition {
      condition     = (coalesce(self.subscription_id, "") == var.az_sub_id)
      error_message = "AzureRM login state subscription ID is not as passed in."
    }
    postcondition {
      condition     = (coalesce(self.object_id, "") != "")
      error_message = "AzureRM login state does not bear a logged-in user object ID."
    }
  }
}

resource "azurerm_resource_group" "my_resource_group" {
  name     = "${var.workload_nickname}-rg-demo"
  location = "centralus"
}
