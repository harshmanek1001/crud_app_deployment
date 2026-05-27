output "name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage.name
}

output "primary_web_endpoint" {
  description = "The primary static website endpoint URL"
  value       = azurerm_storage_account.storage.primary_web_endpoint
}

output "primary_web_host" {
  description = "The primary static website host name (e.g. stname.z23.web.core.windows.net)"
  value       = azurerm_storage_account.storage.primary_web_host
}
