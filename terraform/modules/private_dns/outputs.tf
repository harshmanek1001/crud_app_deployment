output "mysql_dns_zone_name" {
  description = "The name of the Private DNS zone for MySQL"
  value       = azurerm_private_dns_zone.mysql.name
}

output "mysql_dns_zone_id" {
  description = "The ID of the Private DNS zone for MySQL"
  value       = azurerm_private_dns_zone.mysql.id
}

output "vault_dns_zone_name" {
  description = "The name of the Private DNS zone for Vault"
  value       = azurerm_private_dns_zone.vault.name
}

output "vault_dns_zone_id" {
  description = "The ID of the Private DNS zone for Vault"
  value       = azurerm_private_dns_zone.vault.id
}

