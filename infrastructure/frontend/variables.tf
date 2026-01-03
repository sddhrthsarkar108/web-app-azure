variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "frontend_source_path" {
  type        = string
  description = "Path to the frontend source code"
}

variable "vite_client_id" {
  type        = string
  description = "Client ID for the React App"
}

variable "vite_tenant_id" {
  type        = string
  description = "Tenant ID for the React App"
}

variable "vite_api_scope_uri" {
  type        = string
  description = "API Scope URI for the React App"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of the Log Analytics Workspace for diagnostics"
}
