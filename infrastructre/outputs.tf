output "vite_client_id" {
  value = azuread_application.web_app.client_id
}

output "vite_authority" {
  value = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}"
}

output "api_scope_uri" {
  value = "api://${data.azuread_domains.default.domains[0].domain_name}/${var.app_name}/${var.scope_name}"
}

output "test_user_username" {
  value       = azuread_user.test_user.user_principal_name
  description = "Username for the automated test user"
}