infy-subnet = {
  subnet1 = {
    name                 = "infy-frontend-subnet1"
    resource_group_name  = "infy-rg"
    virtual_network_name = "infy-vnet"
    address_prefixes     = ["10.10.1.0/24"]
  }
  subnet2 = {
    name                 = "infy-backend-subnet2"
    resource_group_name  = "infy-rg"
    virtual_network_name = "infy-vnet"
    address_prefixes     = ["10.10.2.0/24"]
  }

}