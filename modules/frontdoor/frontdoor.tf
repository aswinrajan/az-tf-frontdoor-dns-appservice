resource "azurerm_frontdoor" "portfolio-frontdoor" {
  name                = var.front_end_point
  resource_group_name = var.rgname


  routing_rule {
    name               = "portfolioRoutingRule1"
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = [var.front_end_point, var.front_end_point_custom_domain, var.front_end_point_custom_domain_apex]
    forwarding_configuration {
      forwarding_protocol                   = "HttpsOnly"
      backend_pool_name                     = "portfolioBackend"
      cache_enabled                         = true
      cache_query_parameter_strip_directive = "StripNone"
      cache_use_dynamic_compression         = true
    }

  }

  backend_pool_load_balancing {
    name = "portfolioLoadBalancingSettings1"

  }

  backend_pool_health_probe {
    name     = "portfolioHealthProbeSetting1"
    protocol = "Https"
  }

  backend_pool {
    name = "portfolioBackend"
    backend {
      host_header = "${var.appservicename}.azurewebsites.net"
      address     = "${var.appservicename}.azurewebsites.net"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "portfolioLoadBalancingSettings1"
    health_probe_name   = "portfolioHealthProbeSetting1"
  }

  frontend_endpoint {
    name                         = var.front_end_point
    host_name                    = "${var.front_end_point}.azurefd.net"
    session_affinity_enabled     = false
    session_affinity_ttl_seconds = 0
  }
  frontend_endpoint {
    name                         = var.front_end_point_custom_domain
    host_name                    = "www.${var.domain}"
    session_affinity_enabled     = false
    session_affinity_ttl_seconds = 0
  }
  frontend_endpoint {
    name                         = var.front_end_point_custom_domain_apex
    host_name                    = var.domain
    session_affinity_enabled     = false
    session_affinity_ttl_seconds = 0
  }
}
resource "azurerm_frontdoor_custom_https_configuration" "custom_https_configuration_domain" {
  frontend_endpoint_id              = azurerm_frontdoor.portfolio-frontdoor.frontend_endpoints["${var.front_end_point_custom_domain}"]
  custom_https_provisioning_enabled = true
  custom_https_configuration {
    certificate_source = "FrontDoor"
  }
}
resource "azurerm_frontdoor_custom_https_configuration" "custom_https_configuration_domain_apex" {
  frontend_endpoint_id              = azurerm_frontdoor.portfolio-frontdoor.frontend_endpoints["${var.front_end_point_custom_domain_apex}"]
  custom_https_provisioning_enabled = true
  custom_https_configuration {
    certificate_source                      = "AzureKeyVault"
    azure_key_vault_certificate_secret_name = var.kv-secret-name
    azure_key_vault_certificate_vault_id    = var.kv-id
  }
}
 
