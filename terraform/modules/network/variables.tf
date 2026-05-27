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

variable "vnet_address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "appgw_subnet_prefix" {
  description = "Address prefix for AppGW subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "backend_subnet_prefix" {
  description = "Address prefix for Backend subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "database_subnet_prefix" {
  description = "Address prefix for Database subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "pe_subnet_prefix" {
  description = "Address prefix for Private Endpoint subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "frontend_pe_subnet_prefix" {
  description = "Address prefix for Frontend Private Endpoint subnet"
  type        = string
  default     = "10.0.5.0/24"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
