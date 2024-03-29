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
    resource_group_name  = "tamopstfstates"
    storage_account_name = "tamopstf856fw017rbsal"
    container_name       = "tfstatedevops"
    key                  = "aks.main.tfstate"
  }
}

provider "azurerm" {
  features {}
}