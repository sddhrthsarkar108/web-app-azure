variable "app_name" {
  type        = string
  description = "The display name for the App Registration"
}

variable "scope_name" {
  type        = string
  description = "The name of the scope to expose"
}

variable "redirect_uris" {
  type        = list(string)
  description = "Redirect URIs for the application"
}

variable "frontend_endpoint_host_name" {
  type        = string
  description = "Hostname of the Front Door endpoint to add to redirect URIs"
}

variable "storage_website_url" {
  type        = string
  description = "The primary web endpoint of the storage account (e.g. from module.frontend)"
}

variable "domain_name" {
  type        = string
  description = "Domain name to use for identifiers (e.g. contoso.onmicrosoft.com)"
}

variable "test_user_password" {
  type        = string
  description = "Password for the automated test user"
  sensitive   = true
}
