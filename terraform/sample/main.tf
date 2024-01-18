terraform {
  required_version = ">= 1.5.7"
  backend "azurerm" {
    resource_group_name  = "tamopstfstates"
    storage_account_name = "tamopstf856fw017rbsal"
    container_name       = "tfstatedevops"
    key                  = "sample.main.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-example"
  location = "japanwest"
}

#Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create Subnet
resource "azurerm_subnet" "subnet" {
  count                = 5
  name                 = "subnet${count.index}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.${count.index}.0/24"]
}