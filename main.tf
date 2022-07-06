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

module "dns" {
  source   = "./modules/dns"
  rgname   = azurerm_resource_group.portfolio-rg.name
  prefix   = var.prefix
  location = var.location

}

module "cdn" {
  source   = "./modules/cdn"
  rgname   = azurerm_resource_group.portfolio-rg.name
  prefix   = var.prefix
  location = var.location
}


module "appservice" {
  source   = "./modules/appservice"
  rgname   = azurerm_resource_group.portfolio-rg.name
  prefix   = var.prefix
  location = var.location
}
