resource "azurerm_monitor_diagnostic_setting" "fd_diag" {
  name                       = "diag-fd-${var.environment}"
  target_resource_id         = azurerm_cdn_frontdoor_profile.fd.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "FrontDoorAccessLog"
  }

  enabled_log {
    category = "FrontDoorHealthProbeLog"
  }

  enabled_log {
    category = "FrontDoorWebApplicationFirewallLog"
  }
}
