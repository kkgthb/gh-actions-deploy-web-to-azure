output "entra_appreg_display_name" {
  value = azuread_application.the_entra_appreg.display_name
}
output "github_environment_name" {
  value = github_repository_environment.the_gh_env.environment
}
output "entra_appreg_fedcred_subject" {
  value = azuread_application_federated_identity_credential.the_entra_appreg_fedcred.subject
}
output "azure_resource_group_name" {
  value = azurerm_resource_group.the_az_rg.name
}
output "azure_function_app_default_hostname" {
  value = azurerm_linux_function_app.the_az_fa.default_hostname
}

