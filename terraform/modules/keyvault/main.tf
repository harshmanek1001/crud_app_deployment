data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                          = "kv-${lower(replace(var.project_name, "-", ""))}-${lower(var.environment)}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

# Assign Key Vault Secrets Officer role to current runner so it can write secrets
resource "azurerm_role_assignment" "current_user_secrets_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.current_user_object_id
}

# Wait for Azure AD RBAC role propagation
resource "time_sleep" "wait_for_rbac" {
  depends_on      = [azurerm_role_assignment.current_user_secrets_officer]
  create_duration = "2m" # Safe margin for role propagation
}

# Generate secure random password for database administrator
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Store database password in Key Vault
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-admin-password"
  value        = random_password.db_password.result
  key_vault_id = azurerm_key_vault.kv.id

  # Critical dependency: ensure role propagation wait finishes before writing secret
  depends_on = [time_sleep.wait_for_rbac]
}

# Private Endpoint for the Key Vault
resource "azurerm_private_endpoint" "kv_pe" {
  name                = "pe-kv-${var.project_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "kv-connection"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# DNS A Record for the Key Vault Private Endpoint
resource "azurerm_private_dns_a_record" "kv" {
  name                = azurerm_key_vault.kv.name
  zone_name           = var.vault_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.kv_pe.private_service_connection[0].private_ip_address]
}
