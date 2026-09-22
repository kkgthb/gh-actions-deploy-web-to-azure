output "resource_group_name" {
  value = azurerm_resource_group.my_resource_group.name
}
output "subscription_id" {
  value = data.azurerm_client_config.current_azurerm_config.subscription_id
}