output "vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.kv.vault_uri
}

output "db_password_secret_versionless_id" {
  description = "The versionless ID of the database password secret"
  value       = azurerm_key_vault_secret.db_password.versionless_id
}

output "db_password_value" {
  description = "The generated database password value"
  value       = random_password.db_password.result
  sensitive   = true
}
