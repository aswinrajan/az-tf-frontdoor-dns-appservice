output "cname-record-name" {
  value = azurerm_dns_cname_record.portfolio-cname-record.name
}

output "dns-name" {
  value = azurerm_dns_zone.portfolio-dns-zone.name
}