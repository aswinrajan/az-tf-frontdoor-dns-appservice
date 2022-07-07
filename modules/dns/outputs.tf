output "a-record-name" {
  value = azurerm_dns_a_record.portfolio-a-record.name
}

output "dns-name" {
  value = azurerm_dns_zone.portfolio-dns-zone.name
}