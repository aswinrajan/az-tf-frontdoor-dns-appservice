terraform {
  backend "remote" {
    organization = "aswinrajan"

    workspaces {
      name = "az-tf-portfolio-infra"
    }
  }

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "portoflio-rg" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags = {
    env = "prod"
    costcentre = "corp"
  }
}

