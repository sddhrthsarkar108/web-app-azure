# The Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.app_name}-${var.environment}"
  location = var.location
  tags     = var.common_tags
}

# Data source for domain (needed for Identity)
data "azuread_domains" "default" {
  only_initial = true
}

data "azuread_client_config" "current" {}

# Identity Module
module "identity" {
  source                      = "./identity"
  app_name                    = var.app_name
  scope_name                  = var.scope_name
  redirect_uris               = var.redirect_uris
  frontend_endpoint_host_name = module.frontend.fd_endpoint_host_name
  storage_website_url         = module.frontend.storage_website_url
  domain_name                 = data.azuread_domains.default.domains[0].domain_name
  test_user_password          = var.test_user_password
}

# Frontend Module
module "frontend" {
  source                     = "./frontend"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  environment                = var.environment
  app_name                   = var.app_name
  tags                       = var.common_tags
  frontend_source_path       = var.frontend_source_path
  vite_client_id             = module.identity.application_client_id
  vite_tenant_id             = data.azuread_client_config.current.tenant_id
  vite_api_scope_uri         = "api://${data.azuread_domains.default.domains[0].domain_name}/${var.app_name}/${var.scope_name}"
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
}

# Monitoring Module
module "monitoring" {
  source              = "./monitoring"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  environment         = var.environment
  app_name            = var.app_name
  tags                = var.common_tags
}
