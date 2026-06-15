resource "azurerm_storage_account" "storage" {
  # Name must be globally unique, 3-24 characters, lowercase alphanumeric only.
  name                     = "st${lower(replace(var.project_name, "-", ""))}${lower(var.environment)}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type

  static_website {
    index_document     = "index.html"
    error_404_document = "index.html"
  }

  tags = var.tags
}
