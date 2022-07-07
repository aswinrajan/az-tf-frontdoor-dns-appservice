resource "random_integer" "random" {
  min = 1
  max = 50000 
}

resource "azurerm_service_plan" "portfolio-appserviceplan" {
  name                = "${var.prefix}-appsp"
  resource_group_name = var.rgname
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "portfolio-webapp" {
  name                = "${var.prefix}${random_integer.random.result}"
  resource_group_name = var.rgname
  location            = azurerm_service_plan.portfolio-appserviceplan.location
  service_plan_id     = azurerm_service_plan.portfolio-appserviceplan.id
  site_config {
    APPINSIGHTS_INSTRUMENTATIONKEY = var.ikey
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.cnxn-string
    ApplicationInsightsAgent_EXTENSION_VERSION = var.ai-agent-version
    APPINSIGHTS_JAVASCRIPT_ENABLED = true    
  }  
}