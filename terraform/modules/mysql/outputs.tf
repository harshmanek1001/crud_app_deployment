output "server_name" {
  description = "The name of the MySQL server"
  value       = azurerm_mysql_flexible_server.mysql.name
}

output "fqdn" {
  description = "The Private FQDN of the MySQL server"
  value       = "${azurerm_mysql_flexible_server.mysql.name}.${var.mysql_dns_zone_name}"
}

output "database_name" {
  description = "The database name"
  value       = azurerm_mysql_flexible_database.db.name
}

output "server_id" {
  description = "The Resource ID of the MySQL server"
  value       = azurerm_mysql_flexible_server.mysql.id
}

