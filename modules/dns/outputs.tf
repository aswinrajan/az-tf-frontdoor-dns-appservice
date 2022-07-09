output "domain" {
  value = azurerm_dns_zone.portfolio-dns-zone.name
}

output "cnamerecordname" {
  value = azurerm_dns_cname_record.portfolio-cname-record.fqdn
}
