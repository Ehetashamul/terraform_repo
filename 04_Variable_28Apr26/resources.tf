variable "rg_name" {
    type = string
    default = "tpg_lab_aus"
    description = "tpg australia resource group for lob"
}

variable "rg_name2" {
    type = string
    default = "tpg_lab_aus2"
    description = "tpg australia resource group for lob"
}

variable "rg_name3" {
    type = string
    default = "tpg_lab_aus3"
    description = "tpg australia resource group for lob"
}

resource "azurerm_resource_group" "tpg_lab1" {
    name = var.rg_name
    location = "Central India"
}

resource "azurerm_resource_group" "tpg_lab2" {
    name = var.rg_name2
    location = "Central India"
}


resource "azurerm_resource_group" "tpg_lab3" {
    name = var.rg_name3
    location = "Central India"
}