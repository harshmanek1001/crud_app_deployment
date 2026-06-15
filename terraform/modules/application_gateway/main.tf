resource "azurerm_public_ip" "appgw" {
  name                = "pip-appgw-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

locals {
  backend_address_pool_frontend_name = "pool-frontend"
  backend_address_pool_backend_name  = "pool-backend"
  http_setting_frontend_name         = "settings-frontend"
  http_setting_backend_name          = "settings-backend"
  listener_name                      = "listener-http"
  listener_https_name                = "listener-https"
  request_routing_rule_name          = "rule-routing"
  request_routing_rule_https_name    = "rule-routing-https"
  frontend_port_name                 = "port-http"
  frontend_port_https_name           = "port-https"
  frontend_ip_config_name            = "ipconfig-public"
  gateway_ip_config_name             = "gw-ipconfig"
  url_path_map_name                  = "url-path-map"
  redirect_rule_name                 = "redirect-http-to-https"

  # Default self-signed certificate fallback if none provided (Password123!)
  default_pfx_base64     = "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"
  default_pfx_passphrase = "Password123!"

  ssl_cert_data     = var.ssl_certificate_pfx_base64 != null ? var.ssl_certificate_pfx_base64 : local.default_pfx_base64
  ssl_cert_password = var.ssl_certificate_passphrase != null ? var.ssl_certificate_passphrase : local.default_pfx_passphrase
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku {
    name     = var.enable_waf ? "WAF_v2" : "Standard_v2"
    tier     = var.enable_waf ? "WAF_v2" : "Standard_v2"
    capacity = 1 # Single zone/minimal footprint for dev
  }

  dynamic "waf_configuration" {
    for_each = var.enable_waf ? [1] : []
    content {
      enabled          = true
      firewall_mode    = var.waf_firewall_mode
      rule_set_type    = "OWASP"
      rule_set_version = "3.2"
    }
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_config_name
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = local.frontend_port_https_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  ssl_certificate {
    name     = "appgw-ssl-cert"
    data     = local.ssl_cert_data
    password = local.ssl_cert_password
  }

  # Backend Address Pools
  backend_address_pool {
    name  = local.backend_address_pool_frontend_name
    fqdns = [var.frontend_storage_web_host]
  }

  backend_address_pool {
    name  = local.backend_address_pool_backend_name
    fqdns = [var.backend_app_service_fqdn]
  }

  # Backend HTTP Settings
  backend_http_settings {
    name                                = local.http_setting_frontend_name
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 30
    pick_host_name_from_backend_address = true
    probe_name                          = "probe-frontend"
  }

  backend_http_settings {
    name                                = local.http_setting_backend_name
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 30
    pick_host_name_from_backend_address = true
    probe_name                          = "probe-backend"
  }

  # Health Probes
  probe {
    name                                      = "probe-frontend"
    protocol                                  = "Https"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
    match {
      status_code = ["200-399"]
    }
  }

  probe {
    name                                      = "probe-backend"
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
    match {
      # Allow 200-499 to handle cases where backend is running but database is not initialized yet (which might throw 500 or 404).
      # This ensures the Application Gateway doesn't mark the backend as unhealthy during setup/deployment phases.
      status_code = ["200-499"]
    }
  }

  # HTTP Listener
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_config_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  # HTTPS Listener
  http_listener {
    name                           = local.listener_https_name
    frontend_ip_configuration_name = local.frontend_ip_config_name
    frontend_port_name             = local.frontend_port_https_name
    protocol                       = "Https"
    ssl_certificate_name           = "appgw-ssl-cert"
  }

  # HTTP to HTTPS Redirect Configuration
  redirect_configuration {
    name                 = local.redirect_rule_name
    redirect_type        = "Permanent"
    target_listener_name = local.listener_https_name
    include_path         = true
    include_query_string = true
  }

  # Route HTTP traffic to HTTPS Redirect
  request_routing_rule {
    name                        = local.request_routing_rule_name
    rule_type                   = "Basic"
    http_listener_name          = local.listener_name
    redirect_configuration_name = local.redirect_rule_name
    priority                    = 90
  }

  # Path-Based Request Routing Rule for HTTPS
  request_routing_rule {
    name               = local.request_routing_rule_https_name
    rule_type          = "PathBasedRouting"
    http_listener_name = local.listener_https_name
    url_path_map_name  = local.url_path_map_name
    priority           = 100
  }

  # URL Path Map defining routing rules
  url_path_map {
    name                               = local.url_path_map_name
    default_backend_address_pool_name  = local.backend_address_pool_frontend_name
    default_backend_http_settings_name = local.http_setting_frontend_name

    path_rule {
      name                       = "api-route"
      paths                      = ["/api/*", "/api"]
      backend_address_pool_name  = local.backend_address_pool_backend_name
      backend_http_settings_name = local.http_setting_backend_name
    }
  }
}
