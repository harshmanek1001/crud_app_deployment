resource "azurerm_role_assignment" "acrpull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = var.principal_id
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = var.vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.principal_id
}

