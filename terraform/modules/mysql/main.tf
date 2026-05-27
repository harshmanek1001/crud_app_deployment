resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "mysql-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  backup_retention_days  = 7 # Minimum allowed by Azure Flexible Server API (customizable, but 7 is minimum)
  sku_name               = "B_Standard_B1ms" # Burstable SKU, lowest cost
  version                = "8.0.21" # MySQL version 8.0

  storage {
    size_gb = 20 # Minimum storage size
  }

  lifecycle {
    ignore_changes = [
      zone,
      high_availability.0.standby_availability_zone
    ]
  }

  tags = var.tags
}

# Provision a placeholder database inside the server
resource "azurerm_mysql_flexible_database" "db" {
  name                = var.db_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_0900_ai_ci"
}

# Private Endpoint for the MySQL Flexible Server
resource "azurerm_private_endpoint" "mysql_pe" {
  name                = "pe-mysql-${var.project_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "mysql-connection"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# A Record in the Private DNS Zone pointing to the Private Endpoint IP
resource "azurerm_private_dns_a_record" "mysql" {
  name                = azurerm_mysql_flexible_server.mysql.name
  zone_name           = var.mysql_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.mysql_pe.private_service_connection[0].private_ip_address]
}
