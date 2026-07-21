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
  subnet3 = {
    name                 = "infy-subnet3"
    resource_group_name  = "infy-rg2"
    virtual_network_name = "infy-vnet2"
    address_prefixes     = ["10.20.2.0/24"]
  }
}