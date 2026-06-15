# AppGW NSG
resource "azurerm_network_security_group" "appgw" {
  name                = "nsg-appgw-${var.project_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-HTTP-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-GatewayManager"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }
}

data "azurerm_subnet" "appgw" {
  name                 = split("/", var.appgw_subnet_id)[10]
  virtual_network_name = split("/", var.appgw_subnet_id)[8]
  resource_group_name  = split("/", var.appgw_subnet_id)[4]
}

data "azurerm_subnet" "backend" {
  name                 = split("/", var.backend_subnet_id)[10]
  virtual_network_name = split("/", var.backend_subnet_id)[8]
  resource_group_name  = split("/", var.backend_subnet_id)[4]
}

# Backend NSG
resource "azurerm_network_security_group" "backend" {
  name                = "nsg-backend-${var.project_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-AppGW-Inbound-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = data.azurerm_subnet.appgw.address_prefixes[0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-AppGW-Inbound-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = data.azurerm_subnet.appgw.address_prefixes[0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-AppGW-Inbound-Port5000"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = data.azurerm_subnet.appgw.address_prefixes[0]
    destination_address_prefix = "*"
  }
}

# Database NSG
resource "azurerm_network_security_group" "database" {
  name                = "nsg-db-${var.project_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-Backend-Inbound-MySQL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = data.azurerm_subnet.backend.address_prefixes[0]
    destination_address_prefix = "*"
  }
}

# Private Endpoint NSG
resource "azurerm_network_security_group" "pe" {
  name                = "nsg-pe-${var.project_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Frontend Private Endpoint NSG
resource "azurerm_network_security_group" "frontend_pe" {
  name                = "nsg-fe-pe-${var.project_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# NSG Subnet Associations
resource "azurerm_subnet_network_security_group_association" "appgw" {
  subnet_id                 = var.appgw_subnet_id
  network_security_group_id = azurerm_network_security_group.appgw.id
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = var.backend_subnet_id
  network_security_group_id = azurerm_network_security_group.backend.id
}

resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = var.database_subnet_id
  network_security_group_id = azurerm_network_security_group.database.id
}

resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = var.pe_subnet_id
  network_security_group_id = azurerm_network_security_group.pe.id
}

resource "azurerm_subnet_network_security_group_association" "frontend_pe" {
  subnet_id                 = var.frontend_pe_subnet_id
  network_security_group_id = azurerm_network_security_group.frontend_pe.id
}
