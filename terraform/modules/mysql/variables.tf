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

variable "mysql_dns_zone_id" {
  description = "MySQL Private DNS Zone ID"
  type        = string
}

variable "mysql_dns_zone_name" {
  description = "MySQL Private DNS Zone Name"
  type        = string
}

variable "db_admin_username" {
  description = "Administrator login for MySQL"
  type        = string
  default     = "mysqladmin"
}

variable "db_admin_password" {
  description = "Administrator password for MySQL"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name to create"
  type        = string
  default     = "trainee_db"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
