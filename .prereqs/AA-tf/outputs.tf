output "azure_nonprod_resource_group_name" {
  value = module.azure_nonprod.resource_group_name
}
output "azure_prod_resource_group_name" {
  value = module.azure_prod.resource_group_name
}
output "github_repo_full_name" {
  value = module.github.repo_full_name
}
