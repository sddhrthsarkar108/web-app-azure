resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Get the ID of the person/service running Terraform
# data "azurerm_client_config" "current" {}

# Grant that person permission to upload to this Storage Account
resource "azurerm_storage_account" "web_storage" {
  name                              = "st${var.environment}${random_string.storage_suffix.result}"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = "Standard"
  account_replication_type          = "RAGRS"
  account_kind                      = "StorageV2"
  infrastructure_encryption_enabled = true
  tags                              = var.tags
}

resource "azurerm_storage_account_static_website" "web_content" {
  storage_account_id = azurerm_storage_account.web_storage.id
  #error_404_document = "index.html"
  index_document = "index.html"
}
