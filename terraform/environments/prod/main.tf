data "azurerm_client_config" "current" {}

# 1. Resource Group
module "resource_group" {
  source       = "../../modules/resource_group"
  project_name = var.project_name
  environment  = var.environment
  location     = var.location
  tags         = local.tags
}

# 2. Networking
module "network" {
  source              = "../../modules/network"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

# 3. Security (NSGs and subnet associations)
module "security" {
  source                = "../../modules/security"
  project_name          = var.project_name
  environment           = var.environment
  location              = var.location
  resource_group_name   = module.resource_group.name
  appgw_subnet_id       = module.network.appgw_subnet_id
  backend_subnet_id     = module.network.backend_subnet_id
  database_subnet_id    = module.network.database_subnet_id
  pe_subnet_id          = module.network.pe_subnet_id
  frontend_pe_subnet_id = module.network.frontend_pe_subnet_id
  tags                  = local.tags
}

# 4. Private DNS (MySQL private zone and links)
module "private_dns" {
  source              = "../../modules/private_dns"
  project_name        = var.project_name
  environment         = var.environment
  resource_group_name = module.resource_group.name
  vnet_id             = module.network.vnet_id
  tags                = local.tags
}

# 5. Storage Account (Frontend static hosting)
module "storage" {
  source                   = "../../modules/storage"
  project_name             = var.project_name
  environment              = var.environment
  location                 = var.location
  resource_group_name      = module.resource_group.name
  account_replication_type = "GRS" # Geo-redundant replication for prod
  tags                     = local.tags
}

# 6. Container Registry (ACR)
module "acr" {
  source              = "../../modules/acr"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  sku                 = "Standard" # Standard registry for prod throughput
  tags                = local.tags
}

# 7. Key Vault (Secret protection and generation)
module "keyvault" {
  source                        = "../../modules/keyvault"
  project_name                  = var.project_name
  environment                   = var.environment
  location                      = var.location
  resource_group_name           = module.resource_group.name
  pe_subnet_id                  = module.network.pe_subnet_id
  vault_dns_zone_name           = module.private_dns.vault_dns_zone_name
  vault_dns_zone_id             = module.private_dns.vault_dns_zone_id
  current_user_object_id        = data.azurerm_client_config.current.object_id
  public_network_access_enabled = false # Locked down keyvault for prod security
  tags                          = local.tags
}

# 8. Database (MySQL Flexible Server + Private Endpoint)
module "mysql" {
  source                = "../../modules/mysql"
  project_name          = var.project_name
  environment           = var.environment
  location              = var.location
  resource_group_name   = module.resource_group.name
  pe_subnet_id          = module.network.pe_subnet_id
  mysql_dns_zone_id     = module.private_dns.mysql_dns_zone_id
  mysql_dns_zone_name   = module.private_dns.mysql_dns_zone_name
  db_admin_username     = var.db_admin_username
  db_admin_password     = module.keyvault.db_password_value
  db_name               = var.db_name
  sku_name              = "GP_Standard_D2ds_v4" # General Purpose for production
  backup_retention_days = 14                    # Production backup policy
  tags                  = local.tags
}

# 9. App Service (Backend Container hosting + VNet integration + Identity)
module "appservice" {
  source                            = "../../modules/appservice"
  project_name                      = var.project_name
  environment                       = var.environment
  location                          = var.location
  resource_group_name               = module.resource_group.name
  backend_subnet_id                 = module.network.backend_subnet_id
  acr_login_server                  = module.acr.login_server
  backend_image_name                = var.backend_image_name
  backend_image_tag                 = var.backend_image_tag
  db_host                           = module.mysql.fqdn
  db_name                           = module.mysql.database_name
  db_user                           = var.db_admin_username
  db_password_secret_versionless_id = module.keyvault.db_password_secret_versionless_id
  sku_name                          = "P1v3" # Production App Service tier
  always_on                         = true   # Prevent sleeping for prod latency
  tags                              = local.tags
}

# 10. Identity Role Assignment (System Managed Identity gets AcrPull on ACR, Key Vault Secrets User on Key Vault)
module "identity" {
  source       = "../../modules/identity"
  principal_id = module.appservice.principal_id
  acr_id       = module.acr.id
  vault_id     = module.keyvault.vault_id
}

# 11. Application Gateway (Routing ingress)
module "application_gateway" {
  source                    = "../../modules/application_gateway"
  project_name              = var.project_name
  environment               = var.environment
  location                  = var.location
  resource_group_name       = module.resource_group.name
  subnet_id                 = module.network.appgw_subnet_id
  backend_app_service_fqdn  = module.appservice.default_hostname
  frontend_storage_web_host = module.storage.primary_web_host
  enable_waf                = var.enable_waf
  waf_firewall_mode         = "Prevention" # Actively block threats on production ingress WAF
  tags                      = local.tags
}

# 12. Monitoring (Log Analytics + Diagnostics settings)
module "monitoring" {
  source                 = "../../modules/monitoring"
  project_name           = var.project_name
  environment            = var.environment
  location               = var.location
  resource_group_name    = module.resource_group.name
  app_service_id         = module.appservice.id
  mysql_server_id        = module.mysql.server_id
  key_vault_id           = module.keyvault.vault_id
  application_gateway_id = module.application_gateway.gateway_id
  tags                   = local.tags
}
