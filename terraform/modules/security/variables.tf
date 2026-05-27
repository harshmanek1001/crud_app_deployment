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

variable "appgw_subnet_id" {
  description = "AppGW Subnet ID"
  type        = string
}

variable "backend_subnet_id" {
  description = "Backend Subnet ID"
  type        = string
}

variable "database_subnet_id" {
  description = "Database Subnet ID"
  type        = string
}

variable "pe_subnet_id" {
  description = "Private Endpoint Subnet ID"
  type        = string
}

variable "frontend_pe_subnet_id" {
  description = "Frontend Private Endpoint Subnet ID"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
