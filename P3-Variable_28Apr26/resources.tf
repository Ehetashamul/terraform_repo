# 1. Varibale argument using CLI. when executed...
# terraform plan it asked for an argument used to name the resource group creation

# variable "tpg_rg1"{}

# resource "azurerm_resource_group" "tpg_resource" {
#   name     = var.tpg_rg1
#   location = "Central India"
# }

# 2. Variable argument using deafult value

# variable "tpg_rg1" {
#     type = string
#     default = "tpg_lab"
#     description = "tpg australia resource"
# }


# resource "azurerm_resource_group" "tpg_resource" {
#   name     = var.tpg_rg1
#   location = "Central India"
# }

# 3. using variable added one more file terraform.tfvars where argument value passed


variable "tpg_rg2" {
    type = string
    default = "tpg_prod_default_rg"
    description = "tpg australia resource2"
}


resource "azurerm_resource_group" "tpg_resource2" {
  name     = var.tpg_rg2
  location = "Central India"
}