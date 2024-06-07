terraform {
  required_version = "1.2.6"
  required_providers {
    azurerm = {
      version = "3.16.0"
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

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}