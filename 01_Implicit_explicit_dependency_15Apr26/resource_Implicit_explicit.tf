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

# Implicit dependency: Terraform infers order automatically
# It sees references (like rg_group7.name) and builds the graph

resource "azurerm_storage_account" "rg_storage7_implicit" {
  name                     = "rgstorage7implicit"
  resource_group_name      = azurerm_resource_group.rg_group7.name
  location                 = azurerm_resource_group.rg_group7.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Explicit dependency: You force Terraform to wait
# Use depends_on when references aren’t enough

resource "azurerm_storage_account" "rg_storage7_explicit" {
  depends_on               = [azurerm_resource_group.rg_group7]
  name                     = "rgstorage7explicit"
  resource_group_name      = "rg-lab7"        # hardcoded name
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "GRS"

}