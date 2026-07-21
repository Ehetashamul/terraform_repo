nics = {
  nic1 = {
    nic_name        = "nic_frontend-vm"
    nic_location    = "centralindia"
    nic_rg_name     = "infy-rg"
    nic_subnet_name = "infy-frontend-subnet1"
    nic_vnet_name   = "infy-vnet"
    nic_pip_name    = "infy-pip-frontend-vm"
  }
  nic2 = {
    nic_name        = "nic_backend-vm"
    nic_location    = "centralindia"
    nic_rg_name     = "infy-rg"
    nic_subnet_name = "infy-backend-subnet2"
    nic_vnet_name   = "infy-vnet"
    nic_pip_name    = "infy-pip-backend-vm"
  }
}