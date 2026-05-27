resource "azurerm_container_registry" "acr" {
  name                = "acr${lower(replace(var.project_name, "-", ""))}${lower(var.environment)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false # As per requirements, no admin credentials

  tags = var.tags
}
