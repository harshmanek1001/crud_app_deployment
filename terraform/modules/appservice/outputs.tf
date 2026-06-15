output "name" {
  description = "The name of the web app"
  value       = azurerm_linux_web_app.app.name
}

output "default_hostname" {
  description = "The default hostname of the web app"
  value       = azurerm_linux_web_app.app.default_hostname
}

output "principal_id" {
  description = "The Principal ID of the System-Assigned Managed Identity"
  value       = azurerm_linux_web_app.app.identity[0].principal_id
}

output "id" {
  description = "The ID of the web app"
  value       = azurerm_linux_web_app.app.id
}

