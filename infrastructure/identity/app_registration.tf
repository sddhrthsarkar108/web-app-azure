data "azuread_client_config" "current" {}

# 1. Create the App Registration
resource "azuread_application" "web_app" {
  display_name = var.app_name
  owners       = [data.azuread_client_config.current.object_id]

  tags = [
    "TerraformManaged",
    "Project:WebAppAzure"
  ]

  # Result: api://yourtenant.onmicrosoft.com/TestClient_TF
  identifier_uris = ["api://${var.domain_name}/${var.app_name}"]

  single_page_application {
    redirect_uris = concat(
      var.redirect_uris,
      ["https://${var.frontend_endpoint_host_name}/"],
      [var.storage_website_url]
    )
  }

  # 2. Expose the API Scope
  api {
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access the API"
      admin_consent_display_name = "Access ${var.app_name}"
      enabled                    = true
      id                         = random_uuid.scope_id.result
      type                       = "User"
      value                      = var.scope_name
    }
  }

  # 3. Define App Roles
  app_role {
    allowed_member_types = ["User"]
    description          = "Admins with full access"
    display_name         = "Admin"
    enabled              = true
    id                   = random_uuid.role_admin.result
    value                = "Admin"
  }

  app_role {
    allowed_member_types = ["User"]
    description          = "Read-only users"
    display_name         = "Reader"
    enabled              = true
    id                   = random_uuid.role_reader.result
    value                = "Reader"
  }
}

# 4. Create the Service Principal
resource "azuread_service_principal" "web_app_sp" {
  client_id = azuread_application.web_app.client_id

  owners = [data.azuread_client_config.current.object_id]

  tags = [
    "TerraformManaged",
    "Project:WebAppAzure"
  ]
}

# UUID Generators
resource "random_uuid" "scope_id" {}
resource "random_uuid" "role_admin" {}
resource "random_uuid" "role_reader" {}
