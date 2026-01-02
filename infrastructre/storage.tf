# 1. Random suffix for Storage (Must be globally unique)
resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

# 2 . Create Storage Account (Static Website)
resource "azurerm_storage_account" "web_storage" {
  name                     = "st${var.environment}${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.common_tags
}

# 3. Enable Static Website (The v4.0+ way)
resource "azurerm_storage_account_static_website" "web_static_site" {
  storage_account_id = azurerm_storage_account.web_storage.id
  index_document     = "index.html"
  error_404_document = "index.html"
}