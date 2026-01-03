output "vite_client_id" {
  value = module.identity.application_client_id
}

output "vite_authority" {
  value = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}"
}

output "api_scope_uri" {
  value = "api://${data.azuread_domains.default.domains[0].domain_name}/${var.app_name}/${var.scope_name}"
}

output "test_user_username" {
  value       = module.identity.test_user_username
  description = "Username for the automated test user"
}

# This is the URL you will visit to test the deployed site
output "storage_website_url" {
  value = module.frontend.storage_primary_web_endpoint
}

output "storage_account_name" {
  value = module.frontend.storage_account_name
}

# Static website container is always $web
output "storage_container_name" {
  value = "$web"
}

output "frontdoor_url" {
  value = "https://${module.frontend.fd_endpoint_host_name}"
}

output "app_insights_connection_string" {
  value     = module.monitoring.application_insights_connection_string
  sensitive = true
}
