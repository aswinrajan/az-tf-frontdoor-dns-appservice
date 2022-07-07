resource "azurerm_dns_zone" "portfolio-dns-zone" {
  name                = var.domain
  resource_group_name = var.rgname
}

resource "azurerm_dns_a_record" "portfolio-a-record" {
  name                = ""
  zone_name           = azurerm_dns_zone.portfolio-dns-zone.name
  resource_group_name = azurerm_dns_zone.portfolio-dns-zone.resource_group_name
  ttl                 = 1
  target_resource_id  = var.webapp-id
}

