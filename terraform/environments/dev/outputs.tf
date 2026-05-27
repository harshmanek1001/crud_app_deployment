output "application_gateway_public_ip" {
  description = "The public IP address of the Application Gateway"
  value       = module.application_gateway.public_ip
}

output "acr_login_server" {
  description = "The login server for the Azure Container Registry"
  value       = module.acr.login_server
}

output "storage_account_name" {
  description = "The name of the Frontend Storage Account"
  value       = module.storage.name
}

output "storage_static_web_endpoint" {
  description = "The static website endpoint for the Frontend Storage Account"
  value       = module.storage.primary_web_endpoint
}

output "database_private_fqdn" {
  description = "The private FQDN of the MySQL server"
  value       = module.mysql.fqdn
}

output "app_service_default_hostname" {
  description = "The default hostname of the backend App Service"
  value       = module.appservice.default_hostname
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = module.keyvault.vault_uri
}

output "key_vault_secret_uri" {
  description = "The Secret URI of the DB Password in Key Vault"
  value       = module.keyvault.db_password_secret_versionless_id
}

