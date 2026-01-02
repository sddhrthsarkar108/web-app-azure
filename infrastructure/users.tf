resource "azuread_user" "test_user" {
  # Result: testuser_tf@yourtenant.onmicrosoft.com
  user_principal_name   = "testuser_tf@${data.azuread_domains.default.domains[0].domain_name}"
  
  display_name          = "Test User TF"
  mail_nickname         = "testuser_tf"
  password              = var.test_user_password
  force_password_change = false
  department            = "Terraform-Test-Accounts"
}

# 2. Assign Test User to "Admin" Role
resource "azuread_app_role_assignment" "test_user_admin" {
  app_role_id         = random_uuid.role_admin.result

  principal_object_id = azuread_user.test_user.object_id
  resource_object_id  = azuread_service_principal.web_app_sp.object_id
}