resource "azurerm_cdn_profile" "portfolio-cdn-profile" {
  name                = "${var.prefix}-cdn-profile"
  location            = var.location
  resource_group_name = var.rgname
  sku                 = "Standard_Verizon"
}

resource "azurerm_cdn_endpoint" "portfolio-cdn-endpoint" {
  name                = "${var.prefix}-cdn-endpoint"
  profile_name        = azurerm_cdn_profile.portfolio-cdn-profile.name
  location            = var.location
  resource_group_name = var.rgname
  is_http_allowed     = "false"

  origin {
    name      = "portfolio-appservice"
    host_name = var.webapp-hostname
  }
}

resource "azurerm_cdn_endpoint_custom_domain" "portfolio-cdn-endpoint-domain" {
  name            = "${var.prefix}-domain-endpoint"
  cdn_endpoint_id = azurerm_cdn_endpoint.portfolio-cdn-endpoint.id
  host_name       = "${var.cname-record-name}.${var.dns-name}"
}