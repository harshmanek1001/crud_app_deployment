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
  request_routing_rule_name          = "rule-routing"
  frontend_port_name                 = "port-http"
  frontend_ip_config_name            = "ipconfig-public"
  gateway_ip_config_name             = "gw-ipconfig"
  url_path_map_name                  = "url-path-map"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-${var.project_name}-${var.environment}-${var.location}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1 # Single zone/minimal footprint for dev
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

  frontend_ip_configuration {
    name                 = local.frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.appgw.id
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

  # Path-Based Request Routing Rule
  request_routing_rule {
    name               = local.request_routing_rule_name
    rule_type          = "PathBasedRouting"
    http_listener_name = local.listener_name
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
