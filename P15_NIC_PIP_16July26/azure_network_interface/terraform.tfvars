nics = {
  nic1 = {
    nic_name      = "nic_frontend-vm"
    nic_location  = "centralindia"
    nic_rg_name   = "infy-rg"
    nic_subnet_id = "/subscriptions/fb84669e-67bb-40cb-8555-8122471924cf/resourceGroups/infy-rg/providers/Microsoft.Network/virtualNetworks/infy-vnet/subnets/infy-frontend-subnet1"
    nic_pip_id    = "/subscriptions/fb84669e-67bb-40cb-8555-8122471924cf/resourceGroups/infy-rg/providers/Microsoft.Network/publicIPAddresses/infy-pip-frontend-vm"
  }
  nic2 = {
    nic_name      = "nic_backend-vm"
    nic_location  = "centralindia"
    nic_rg_name   = "infy-rg"
    nic_subnet_id = "/subscriptions/fb84669e-67bb-40cb-8555-8122471924cf/resourceGroups/infy-rg/providers/Microsoft.Network/virtualNetworks/infy-vnet/subnets/infy-backend-subnet2"
    nic_pip_id    = "/subscriptions/fb84669e-67bb-40cb-8555-8122471924cf/resourceGroups/infy-rg/providers/Microsoft.Network/publicIPAddresses/infy-pip-backend-vm"
  }
}