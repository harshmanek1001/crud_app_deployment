variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "app_service_id" {
  description = "Resource ID of the App Service"
  type        = string
}

variable "mysql_server_id" {
  description = "Resource ID of the MySQL Flexible Server"
  type        = string
}

variable "key_vault_id" {
  description = "Resource ID of the Key Vault"
  type        = string
}

variable "application_gateway_id" {
  description = "Resource ID of the Application Gateway"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
