terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.67.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_group7" {
  name     = "rg-lab7"
  location = "Central India"
}

resource "azurerm_storage_account" "rg_storage" {
  name                     = "rg_group7storage"
  resource_group_name      = azurerm_resource_group.rg_group7.name
  location                 = azurerm_resource_group.rg_group7.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}