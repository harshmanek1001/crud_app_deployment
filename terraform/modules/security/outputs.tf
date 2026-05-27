output "appgw_nsg_id" {
  description = "AppGW NSG ID"
  value       = azurerm_network_security_group.appgw.id
}

output "backend_nsg_id" {
  description = "Backend NSG ID"
  value       = azurerm_network_security_group.backend.id
}

output "database_nsg_id" {
  description = "Database NSG ID"
  value       = azurerm_network_security_group.database.id
}

output "pe_nsg_id" {
  description = "Private Endpoint NSG ID"
  value       = azurerm_network_security_group.pe.id
}

output "frontend_pe_nsg_id" {
  description = "Frontend PE NSG ID"
  value       = azurerm_network_security_group.frontend_pe.id
}
