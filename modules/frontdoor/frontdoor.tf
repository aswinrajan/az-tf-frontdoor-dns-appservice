resource "azurerm_frontdoor" "portfolio-front-door" {
  name                = "${var.prefix}-frontdoorname"
  resource_group_name = var.rgname

  routing_rule {
    name               = "${var.prefix}routingrule-frontdoor"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["${var.prefix}-frontend-endpoint-name"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "${var.prefix}backendpool"
    }
  }

  backend_pool_load_balancing {
    name = "${var.prefix}backend-loab-balancing"
  }

  backend_pool_health_probe {
    name = "${var.prefix}healthprobesetting"
  }

  backend_pool {
    name = "${var.prefix}backendpool"
    backend {
      host_header = "aswinrajan.ca"
      address     = "aswinrajan.ca"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "${var.prefix}backend-loab-balancing"
    health_probe_name   = "${var.prefix}healthprobesetting"
  }

  frontend_endpoint {
    name      = "${var.prefix}-frontend-endpoint-name"
    host_name = "${var.prefix}-frontdoorname.azurefd.net"
  }
}
resource "random_integer" "random" {
  min = 1
  max = 50000
}