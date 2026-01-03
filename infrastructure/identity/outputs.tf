output "application_client_id" {
  value = azuread_application.web_app.client_id
}

output "service_principal_object_id" {
  value = azuread_service_principal.web_app_sp.object_id
}

output "role_admin_id" {
  value = random_uuid.role_admin.result
}

output "test_user_username" {
  value = azuread_user.test_user.user_principal_name
}
