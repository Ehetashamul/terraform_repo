infy-vnet = {
  vnet1 = {

    name                = "infy-vnet1"
    location            = "centralindia"
    resource_group_name = "infy-rg1"
    address_space       = ["10.10.0.0/16"]
  }

vnet2 = {

    name                = "infy-vnet2"
    location            = "eastus"
    resource_group_name = "infy-rg2"
    address_space       = ["10.20.0.0/16"]
  }
}

