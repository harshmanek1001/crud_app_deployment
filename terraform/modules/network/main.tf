resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# 1. AppGW Subnet
resource "azurerm_subnet" "appgw" {
  name                 = "subnet-appgw-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.appgw_subnet_prefix]
}

# 2. Backend Integration Subnet (Delegated to Web Server Farms)
resource "azurerm_subnet" "backend" {
  name                 = "subnet-backend-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.backend_subnet_prefix]

  delegation {
    name = "web_delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# 3. Database Subnet
resource "azurerm_subnet" "database" {
  name                 = "subnet-db-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.database_subnet_prefix]
}

# 4. Private Endpoint Subnet
resource "azurerm_subnet" "pe" {
  name                 = "subnet-pe-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.pe_subnet_prefix]
}

# 5. Frontend Private Endpoint Subnet
resource "azurerm_subnet" "frontend_pe" {
  name                 = "subnet-fe-pe-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.frontend_pe_subnet_prefix]
}
