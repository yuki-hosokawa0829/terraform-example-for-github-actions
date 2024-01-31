# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "azurerm_virtual_network" "example" {
  name                = join("-", [var.prefix, "network"])
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = var.resource_group_name
  dns_servers         = ["10.0.1.4", "168.63.129.16", "8.8.8.8"]
}

resource "azurerm_subnet" "other-resource" {
  name                 = "other-resource"
  address_prefixes     = ["10.0.0.0/24"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
}

resource "azurerm_subnet" "domain-controllers" {
  name                 = "domain-controllers"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
}

resource "azurerm_subnet" "domain-members" {
  name                 = "domain-members"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
}

resource "azurerm_network_security_group" "nsg_dc" {
  name                = join("-", [var.prefix, "nsg-dc"])
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowRDPInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "219.166.164.110"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg_dm" {
  name                = join("-", [var.prefix, "nsg-dm"])
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowRDPInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "219.166.164.110"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_as_dc" {
  subnet_id                 = azurerm_subnet.domain-controllers.id
  network_security_group_id = azurerm_network_security_group.nsg_dc.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_as_dm" {
  subnet_id                 = azurerm_subnet.domain-members.id
  network_security_group_id = azurerm_network_security_group.nsg_dm.id
}