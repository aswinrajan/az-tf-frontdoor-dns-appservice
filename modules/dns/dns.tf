resource "azurerm_dns_zone" "portfolio-dns-zone" {
  name                = var.domain
  resource_group_name = var.rgname
}

resource "azurerm_dns_cname_record" "portfolio-cname-record" {
  name                = "www"
  zone_name           = azurerm_dns_zone.portfolio-dns-zone.name
  resource_group_name = var.rgname
  ttl                 = 1
  record             = var.frontdoorcname
}