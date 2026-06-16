provider "azurerm" {
  subscription_id = "90890b3f-378b-4a93-b801-1e4c32846c06"
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}
