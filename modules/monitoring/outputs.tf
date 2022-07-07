output "ikey" {
  value = azurerm_application_insights.portfolio-webapp-ai.instrumentation_key
}
output "cnxn-string" {
  value = azurerm_application_insights.portfolio-webapp-ai.connection_string
}