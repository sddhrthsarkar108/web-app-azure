output "fd_endpoint_host_name" {
  value = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
}

output "storage_account_name" {
  value = azurerm_storage_account.web_storage.name
}

output "storage_primary_blob_host" {
  value = azurerm_storage_account.web_storage.primary_blob_host
}

output "storage_primary_web_endpoint" {
  value = azurerm_storage_account.web_storage.primary_web_endpoint
}

output "storage_website_url" {
  value = azurerm_storage_account.web_storage.primary_web_endpoint
}
