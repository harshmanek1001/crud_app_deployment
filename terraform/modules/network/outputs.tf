output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Virtual Network Name"
  value       = azurerm_virtual_network.vnet.name
}

output "appgw_subnet_id" {
  description = "Subnet ID for AppGW"
  value       = azurerm_subnet.appgw.id
}

output "backend_subnet_id" {
  description = "Subnet ID for Backend Integration"
  value       = azurerm_subnet.backend.id
}

output "database_subnet_id" {
  description = "Subnet ID for Database"
  value       = azurerm_subnet.database.id
}

output "pe_subnet_id" {
  description = "Subnet ID for Private Endpoints"
  value       = azurerm_subnet.pe.id
}

output "frontend_pe_subnet_id" {
  description = "Subnet ID for Frontend Private Endpoints"
  value       = azurerm_subnet.frontend_pe.id
}
