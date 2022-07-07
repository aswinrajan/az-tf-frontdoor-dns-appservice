resource "azurerm_service_plan" "portfolio-appserviceplan" {
  name                = "${var.prefix}-appsp"
  resource_group_name = var.rgname
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "portfolio-webapp" {
  name                = var.appservicename
  resource_group_name = var.rgname
  location            = azurerm_service_plan.portfolio-appserviceplan.location
  service_plan_id     = azurerm_service_plan.portfolio-appserviceplan.id
  site_config {
    ip_restriction = [
      {
        ip_address                = "147.243.0.0/16",
        virtual_network_subnet_id = null
        subnet_id                 = null
        name                      = "allowfrontdooripv4"
        description               = "allowfrontdooripv4"
        priority                  = 300
        action                    = "Allow"
        }, {
        ip_address                = "2a01:111:2050::/44",
        virtual_network_subnet_id = null
        subnet_id                 = null
        name                      = "allowfrontdooripv6"
        description               = "allowfrontdooripv6"
        priority                  = 350
        action                    = "Allow"
        }, {
        ip_address                = "168.63.129.16/32",
        virtual_network_subnet_id = null
        subnet_id                 = null
        name                      = "azureinfrasvcstart"
        description               = "azureinfrasvcstart"
        priority                  = 400
        action                    = "Allow"
        }, {
        ip_address                = "169.254.169.254/32",
        virtual_network_subnet_id = null
        subnet_id                 = null
        name                      = "azureinfrasvcend "
        description               = "azureinfrasvcend"
        priority                  = 450
        action                    = "Allow"
    }]
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = var.ikey
    APPLICATIONINSIGHTS_CONNECTION_STRING      = var.cnxn-string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~2"
    APPINSIGHTS_JAVASCRIPT_ENABLED             = true
  }
}
