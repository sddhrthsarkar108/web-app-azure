resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                     = "afd-${lower(replace(var.app_name, "_", "-"))}-${var.environment}"
  resource_group_name      = var.resource_group_name
  response_timeout_seconds = 16
  sku_name                 = "Standard_AzureFrontDoor"
  tags                     = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "fde-${lower(replace(var.app_name, "_", "-"))}-${var.environment}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}

resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_group" {
  name                     = "og-default"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }

  health_probe {
    interval_in_seconds = 100
    path                = "/index.html"
    protocol            = "Http"
    request_type        = "HEAD"
  }
}

resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
  depends_on                     = [azurerm_storage_account.web_storage]
  name                           = "origin-storage-web"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = azurerm_storage_account.web_storage.primary_web_host
  origin_host_header             = azurerm_storage_account.web_storage.primary_web_host

  http_port  = 80
  https_port = 443
  priority   = 1
  weight     = 1000
}

resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = "route-default"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fd_origin.id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.caching_rules.id]
  enabled                       = true

  # Removed custom domain integration as it requires pre-configuration
  # cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.ihelpyoutodo_domain.id]

  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]
  link_to_default_domain = true
}
