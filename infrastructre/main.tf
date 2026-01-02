locals {
  # Logic to merge your variable tags with the environment tag
  common_tags = merge(var.common_tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

# The Resource Group is the container for Storage, Front Door, etc.
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.app_name}-${var.environment}"
  location = var.location
  
  tags = local.common_tags
}