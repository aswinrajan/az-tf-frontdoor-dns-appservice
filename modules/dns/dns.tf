resource "azurerm_dns_zone" "portfolio-dns-zone" {
  name                = var.domain
  resource_group_name = var.rgname
}

