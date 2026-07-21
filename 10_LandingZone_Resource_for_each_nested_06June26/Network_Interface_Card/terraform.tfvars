infy-NIC = {
  infy-NIC1 = {
    name                = "infy-NIC1"
    location            = "centralindia"
    resource_group_name = "infy-rg1"

    ip_configuration = {
      name                          = "internal"
      subnet_id                     = "/subscriptions/7a04619b-86b3-4bc8-8b52-8168bd785f0b/resourceGroups/infy-rg1/providers/Microsoft.Network/virtualNetworks/infy-vnet1/subnets/infy-subnet1"
      private_ip_address_allocation = "Dynamic"
    }
  }
  # kite-NIC2 = {
  #   name                = "infy-NIC2"
  #   location            = "centralindia"
  #   resource_group_name = "infy-rg1"

  #   ip_configuration = {
  #     name                          = "internal"
  #     subnet_id                     = "/subscriptions/7a04619b-86b3-4bc8-8b52-8168bd785f0b/resourceGroups/infy-rg1/providers/Microsoft.Network/virtualNetworks/infy-vnet1/subnets/infy-subnet2"
  #     private_ip_address_allocation = "Dynamic"
  #   }
}
