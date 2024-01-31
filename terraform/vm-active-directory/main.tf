# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
terraform {
  required_version = ">= 1.5.7"
  backend "azurerm" {
    resource_group_name  = "tamopstfstates"
    storage_account_name = "tamopstf856fw017rbsal"
    container_name       = "tfstatedevops"
    key                  = "addc.main.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  location = var.location
  name     = "${var.prefix}-rg"
}

module "network" {
  source = "./modules/network"

  location            = var.location
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.example.name
}

module "active-directory-domain" {
  source = "./modules/active-directory-domain"

  resource_group_name           = azurerm_resource_group.example.name
  location                      = azurerm_resource_group.example.location
  active_directory_domain_name  = "${var.prefix}.local"
  active_directory_netbios_name = var.prefix
  admin_username                = var.admin_username
  admin_password                = var.admin_password
  prefix                        = var.prefix
  subnet_id                     = module.network.domain_controllers_subnet_id
}
