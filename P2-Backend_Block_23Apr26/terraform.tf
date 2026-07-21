terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.69.0"
    }
  }

}

provider "azurerm" {
  features {

  }

}

resource "azurerm_resource_group" "label1" {

  name     = "rg-lab1a"
  location = "Central India"
}

resource "azurerm_storage_account" "label2" {

  name                     = "lab1storagea"
  resource_group_name      = azurerm_resource_group.label1.name
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
