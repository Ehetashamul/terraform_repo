terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.73.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "rg-700"
    storage_account_name  = "stora17101"
    container_name        = "container700"
    key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    
  }
}
