terraform {
  backend "remote" {
    organization = "aswinrajan"

    workspaces {
      name = "az-tf-portfolio-infra"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "portfolio-rg" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags = {
    env        = "prod"
    costcentre = "corp"
  }
}
data "azurerm_subscription" "current" {
}


module "dns" {
  source   = "./modules/dns"
  rgname   = azurerm_resource_group.portfolio-rg.name
  prefix   = var.prefix
  location = var.location
  cdn-endpoint-id = module.cdn.cdn-endpoint-id
}

module "cdn" {
  source   = "./modules/cdn"
  rgname   = azurerm_resource_group.portfolio-rg.name
  prefix   = var.prefix
  location = var.location
  webapp-hostname   = module.appservice.webapp-hostname
  cname-record-name = module.dns.cname-record-name
  dns-name = module.dns.dns-name
}


module "appservice" {
  source   = "./modules/appservice"
  rgname   = azurerm_resource_group.portfolio-rg.name
  prefix   = var.prefix
  location = var.location
  ikey = module.monitoring.ikey
  cnxn-string = module.monitoring.cnxn-string
}

module "monitoring" {
  source   = "./modules/monitoring"
  rgname   = azurerm_resource_group.portfolio-rg.name
  prefix   = var.prefix
  location = var.location
  subscription = data.azurerm_subscription.current.display_name
  appservicename = module.appservice.appservicename
}