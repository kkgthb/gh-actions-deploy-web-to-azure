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
