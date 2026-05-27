variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "crudapp"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "koreacentral"
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
  default     = "latest"
}
