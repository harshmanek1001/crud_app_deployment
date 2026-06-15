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

variable "backend_subnet_id" {
  description = "Subnet ID for regional VNet integration"
  type        = string
}

variable "acr_login_server" {
  description = "The login server of the ACR"
  type        = string
}

variable "backend_image_name" {
  description = "Name of the backend image in ACR"
  type        = string
  default     = "backend"
}

variable "backend_image_tag" {
  description = "Tag of the backend image in ACR"
  type        = string
  default     = "latest"
}

variable "db_host" {
  description = "Database host FQDN"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database administrator username"
  type        = string
}

variable "db_password_secret_versionless_id" {
  description = "The versionless ID of the database password secret in Key Vault"
  type        = string
}


variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  description = "The SKU SKU name for the Service Plan"
  type        = string
  default     = "B1"
}

variable "always_on" {
  description = "Should the app always be on"
  type        = bool
  default     = false
}

