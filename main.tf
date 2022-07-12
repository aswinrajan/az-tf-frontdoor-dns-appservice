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
resource "random_integer" "random" {
  min = 1
  max = 50000
}
locals {
  appsvc-name = "${var.prefix}${random_integer.random.result}"
}


module "dns" {
  source   = "./modules/dns"
  rgname   = azurerm_resource_group.portfolio-rg.name
  prefix   = var.prefix
  location = var.location
}

module "appservice" {
  source         = "./modules/appservice"
  rgname         = azurerm_resource_group.portfolio-rg.name
  prefix         = var.prefix
  location       = var.location
  ikey           = module.monitoring.ikey
  cnxn-string    = module.monitoring.cnxn-string
  appservicename = local.appsvc-name
}

module "monitoring" {
  source         = "./modules/monitoring"
  rgname         = azurerm_resource_group.portfolio-rg.name
  prefix         = var.prefix
  location       = var.location
  subscription   = data.azurerm_subscription.current.display_name
  appservicename = local.appsvc-name
}
module "frontdoor" {
  source         = "./modules/frontdoor"
  rgname         = azurerm_resource_group.portfolio-rg.name
  prefix         = var.prefix
  location       = var.location
  appservicename = local.appsvc-name
  domain         = module.dns.domain
  kv-secret-name = module.keyvault.kv-secret-name
  kv-id          = module.keyvault.kv-id
  depends_on = [
    module.keyvault.kv-secret-name
  ]
}

module "keyvault" {
  source   = "./modules/keyvault"
  prefix   = var.prefix
  location = var.location
  rgname   = azurerm_resource_group.portfolio-rg.name
}


