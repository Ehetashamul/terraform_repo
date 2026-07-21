infy = {
  rg1 = {
    name     = "infy-rg1"
    location = "centralindia"
  }
}

infy-vnet = {
  vnet1 = {
    name                = "infy-vnet1"
    location            = "centralindia"
    resource_group_name = "infy-rg1"
    address_space       = ["10.10.0.0/16"]
  }

}

infy-subnet = {
  subnet1 = {
    name                 = "infy-subnet1"
    resource_group_name  = "infy-rg1"
    virtual_network_name = "infy-vnet1"
    address_prefixes     = ["10.10.0.0/24"]
  }
  subnet2 = {
    name                 = "infy-subnet2"
    resource_group_name  = "infy-rg1"
    virtual_network_name = "infy-vnet1"
    address_prefixes     = ["10.10.1.0/24"]
  }

}