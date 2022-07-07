resource "azurerm_frontdoor_firewall_policy" "portfoliowafpolicy" {
  name                              = "${var.prefix}-wafpolicy"
  resource_group_name               = var.rgname
  enabled                           = true
  mode                              = "Prevention"
  custom_block_response_status_code = 403 

  custom_block_response_body        = "YmxvY2tlZCBieSBmcm9udGRvb3I="

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  }
}

resource "azurerm_frontdoor" "portfolio-frontdoor" {
  name                                         = var.front_end_point
  resource_group_name                          = var.rgname
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = "portfolioRoutingRule1"
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = [var.front_end_point]
    forwarding_configuration {
      forwarding_protocol = "HttpsOnly"
      backend_pool_name   = "portfolioBackend"
      cache_enabled = true
      cache_query_parameter_strip_directive = "StripNone"
      cache_use_dynamic_compression         = true  
    }

  }

  backend_pool_load_balancing {
    name = "portfolioLoadBalancingSettings1"

  }

  backend_pool_health_probe {
    name = "portfolioHealthProbeSetting1"
    protocol              = "Https"
  }

  backend_pool {
    name = "portfolioBackend"
    backend {
      host_header = "${var.appservicename}.azurewebsites.net" 
      address = "${var.appservicename}.azurewebsites.net" 
      http_port   =  80
      https_port  =  443
    }

    load_balancing_name = "portfolioLoadBalancingSettings1"
    health_probe_name   = "portfolioHealthProbeSetting1"
  }

  frontend_endpoint {
    name                              = var.front_end_point 
    host_name                         = "${var.front_end_point}.azurefd.net"
    session_affinity_enabled          = false 
    session_affinity_ttl_seconds      = 0     
    custom_https_provisioning_enabled = false
    web_application_firewall_policy_link_id = azurerm_frontdoor_firewall_policy.portfoliowafpolicy.id
  }
}