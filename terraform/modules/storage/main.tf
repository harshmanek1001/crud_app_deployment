resource "azurerm_storage_account" "storage" {
  # Name must be globally unique, 3-24 characters, lowercase alphanumeric only.
  name                     = "st${lower(replace(var.project_name, "-", ""))}${lower(var.environment)}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type

  tags = var.tags
}

resource "azurerm_storage_account_static_website" "storage" {
  storage_account_id = azurerm_storage_account.storage.id
  index_document     = "index.html"
  error_404_document = "index.html"
}
