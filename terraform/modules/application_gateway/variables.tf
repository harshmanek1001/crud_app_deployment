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

variable "subnet_id" {
  description = "Subnet ID for Application Gateway"
  type        = string
}

variable "backend_app_service_fqdn" {
  description = "FQDN of Backend App Service (e.g. app-name.azurewebsites.net)"
  type        = string
}

variable "frontend_storage_web_host" {
  description = "FQDN of Frontend Storage Account Web Host (e.g. stname.z23.web.core.windows.net)"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

variable "enable_waf" {
  description = "Enable Web Application Firewall on Application Gateway"
  type        = bool
  default     = false
}

variable "waf_firewall_mode" {
  description = "WAF firewall mode (Detection or Prevention)"
  type        = string
  default     = "Detection"
}

variable "ssl_certificate_pfx_base64" {
  description = "Base64 encoded PFX certificate for HTTPS listener"
  type        = string
  default     = null
}

variable "ssl_certificate_passphrase" {
  description = "Passphrase for the PFX certificate"
  type        = string
  default     = null
  sensitive   = true
}

