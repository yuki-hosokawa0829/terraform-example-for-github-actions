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
  count                = 3
  name                 = "subnet${count.index}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.${count.index}.0/24"]
}

# Create NSG
resource "azurerm_network_security_group" "nsg" {
  count               = 3
  name                = "nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule = {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "219.166.164.110"
    destination_address_prefix = "*"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  count                 = 3
  subnet_id             = azurerm_subnet.subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg[count.index].id
}