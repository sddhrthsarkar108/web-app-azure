variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "app_name" {
  default = "TestClient_TF"
  description = "The display name for the App Registration"
}

variable "environment" {
  type        = string
  default     = "dev"
}

variable "location" {
  type        = string
  default     = "East US"
}

variable "scope_name" {
  default = "ourapi" 
  description = "The name of the scope to expose (e.g. ouapi or ourapi)"
}

variable "redirect_uris" {
  type    = list(string)
  default = ["https://localhost:5173/"]
  description = "Redirect URIs for frontend"
}

variable "test_user_password" {
  type        = string
  description = "Password for the automated test user"
  sensitive   = true
}

variable "common_tags" {
  type = map(string)
  default = {
    Project     = "WebAppAzure"
    ManagedBy   = "Terraform"
  }
  description = "Tags to apply to all Azure RM resources"
}