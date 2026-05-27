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

variable "pe_subnet_id" {
  description = "Subnet ID where Private Endpoint will be deployed"
  type        = string
}

variable "vault_dns_zone_name" {
  description = "Vault Private DNS Zone Name"
  type        = string
}

variable "vault_dns_zone_id" {
  description = "Vault Private DNS Zone ID"
  type        = string
}

variable "current_user_object_id" {
  description = "Object ID of the current logged-in Azure user to assign Secrets Officer role"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
