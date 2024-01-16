terraform {
  required_version = ">=v1.1.4"
  required_providers {
    azurerm = {
      version = "~>2.36.0"
      source  = "hashicorp/azurerm"
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