variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "app_name" {
  type        = string
  description = "Application name for naming resources"
}

variable "environment" {
  type        = string
  description = "Environment (dev, prod, etc.)"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}
