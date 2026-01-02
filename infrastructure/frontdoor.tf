# 1. Front Door Profile (Standard Tier)
resource "azurerm_cdn_frontdoor_profile" "fd" {
  # FIX: Replace underscores with hyphens and make lowercase
  name                = "afd-${lower(replace(var.app_name, "_", "-"))}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"

  tags = local.common_tags
  
  # Managed Identity to authenticate with Storage
  identity {
    type = "SystemAssigned"
  }
}

# 2. Endpoint (The public URL)
resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  # FIX: Apply replace() and lower() here too
  name                     = "fde-${lower(replace(var.app_name, "_", "-"))}-${var.environment}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}

# 3. Origin Group
resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_group" {
  name                     = "og-default"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/content/index.html"
    protocol            = "Https"
    interval_in_seconds = 100
    request_type        = "HEAD"
  }
}

# 4. Origin (Pointing to Storage)
resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
  name                          = "origin-storage"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id

  enabled                        = true
  host_name                      = azurerm_storage_account.web_storage.primary_blob_host
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_storage_account.web_storage.primary_blob_host
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

# 5. Route
resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = "route-default"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fd_origin.id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.spa_rules.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}

# 6. GRANT ACCESS: Allow Front Door Identity to read Private Storage
resource "azurerm_role_assignment" "fd_read_storage" {
  scope                = azurerm_storage_account.web_storage.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_cdn_frontdoor_profile.fd.identity[0].principal_id
}