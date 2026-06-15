variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "crudapp"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variable must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "koreacentral"

  validation {
    condition     = length(var.location) > 0
    error_message = "The location variable must not be empty."
  }
}

variable "db_admin_username" {
  description = "Administrator login for MySQL"
  type        = string
  default     = "mysqladmin"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "trainee_db"
}

variable "backend_image_name" {
  description = "Name of the backend image in ACR"
  type        = string
  default     = "backend"
}

variable "backend_image_tag" {
  description = "Tag of the backend image in ACR"
  type        = string
  default     = "v1.0.0"

  validation {
    condition     = length(var.backend_image_tag) > 0 && (var.environment != "prod" || var.backend_image_tag != "latest")
    error_message = "The backend_image_tag must not be empty, and must not be 'latest' for prod environment."
  }
}

variable "enable_waf" {
  description = "Enable Web Application Firewall on Application Gateway"
  type        = bool
  default     = true
}
