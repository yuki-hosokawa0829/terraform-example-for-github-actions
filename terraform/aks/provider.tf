terraform {
  required_version = ">=v1.1.4"
  required_providers {
    azurerm = {
      version = "~>2.36.0"
      source  = "hashicorp/azurerm"
    }
    azapi = {
      version = "~>1.0.0"
      source  = "azure/azapi"
    }
    random = {
      version = "~>2.2.0"
      source  = "hashicorp/random"
    }
  }
  backend "azurerm" {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = var.backend_key
  }
}

provider "azurerm" {
  features {}
}