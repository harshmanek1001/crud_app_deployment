resource "azurerm_service_plan" "asp" {
  name                = "asp-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name

  tags = var.tags
}

resource "azurerm_linux_web_app" "app" {
  name                      = "app-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  service_plan_id           = azurerm_service_plan.asp.id
  virtual_network_subnet_id = var.backend_subnet_id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                               = var.always_on
    container_registry_use_managed_identity = true

    application_stack {
      docker_image_name   = "${var.backend_image_name}:${var.backend_image_tag}"
      docker_registry_url = "https://${var.acr_login_server}"
    }
  }

  app_settings = {
    "DB_HOST"       = var.db_host
    "DB_USER"       = var.db_user
    "DB_PASSWORD"   = "@Microsoft.KeyVault(SecretUri=${var.db_password_secret_versionless_id})"
    "DB_NAME"       = var.db_name
    "PORT"          = "5000"
    "WEBSITES_PORT" = "5000"
  }

  tags = var.tags
}
