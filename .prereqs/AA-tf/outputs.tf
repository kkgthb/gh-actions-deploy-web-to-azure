output "nonprod_entra_appreg_display_name" {
  value = module.nonprod_env_config.entra_appreg_display_name
}
output "nonprod_github_environment_name" {
  value = module.nonprod_env_config.github_environment_name
}
output "nonprod_entra_appreg_fedcred_subject" {
  value = module.nonprod_env_config.entra_appreg_fedcred_subject
}
output "nonprod_azure_resource_group_name" {
  value = module.nonprod_env_config.azure_resource_group_name
}
output "nonprod_azure_function_app_default_hostname" {
  value = module.nonprod_env_config.azure_function_app_default_hostname
}

output "prod_entra_appreg_display_name" {
  value = module.prod_env_config.entra_appreg_display_name
}
output "prod_github_environment_name" {
  value = module.prod_env_config.github_environment_name
}
output "prod_entra_appreg_fedcred_subject" {
  value = module.prod_env_config.entra_appreg_fedcred_subject
}
output "prod_azure_resource_group_name" {
  value = module.prod_env_config.azure_resource_group_name
}
output "prod_azure_function_app_default_hostname" {
  value = module.prod_env_config.azure_function_app_default_hostname
}
