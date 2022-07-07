resource "azurerm_log_analytics_workspace" "portfolio-law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.rgname
  sku                 = "PerGB2018"
  retention_in_days   = 30 
}

resource "azurerm_application_insights" "portfolio-webapp-ai" {
  name                = "${var.prefix}-ai"
  location            = var.location
  resource_group_name = var.rgname
  workspace_id        = azurerm_log_analytics_workspace.portfolio-law.id
  application_type    = "web"
  tags = {
    "hidden-link:/subscriptions/${var.subscription}/resourceGroups/${var.rgname}/providers/Microsoft.Web/sites/${var.appservicename}" = "Resource"
  }
}