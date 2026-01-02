resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Get the ID of the person/service running Terraform
data "azurerm_client_config" "current" {}

# Grant that person permission to upload to this Storage Account
resource "azurerm_role_assignment" "upload_permissions" {
  scope                = azurerm_storage_account.web_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_storage_account" "web_storage" {
  name                     = "st${var.environment}${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # FIX: Updated for AzureRM v4.0+
  # Replaces 'allow_blob_public_access = false'
  allow_nested_items_to_be_public = false

  tags = local.common_tags
}

resource "azurerm_storage_container" "web_content" {
  name                  = "content"
  storage_account_id    = azurerm_storage_account.web_storage.id
  container_access_type = "private"
}