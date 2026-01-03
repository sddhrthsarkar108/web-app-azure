resource "random_string" "monitoring_suffix" {
  length  = 6
  special = false
  upper   = false
}

# 1. Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "analytics" {
  name                = "law-${lower(var.app_name)}-${var.environment}-${random_string.monitoring_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# 2. Application Insights
resource "azurerm_application_insights" "app_insights" {
  name                = "ai-${lower(var.app_name)}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.analytics.id
  tags                = var.tags
}
