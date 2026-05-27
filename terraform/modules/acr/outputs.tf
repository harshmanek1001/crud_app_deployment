output "name" {
  description = "The name of the container registry"
  value       = azurerm_container_registry.acr.name
}

output "login_server" {
  description = "The login server URL for the container registry"
  value       = azurerm_container_registry.acr.login_server
}

output "id" {
  description = "The container registry ID"
  value       = azurerm_container_registry.acr.id
}
