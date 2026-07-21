vms = {
  nic1 = {
    nic_name                = "nic_frontend-vm"
    location                = "centralindia"
    rg_name                 = "infy-rg"
    nic_subnet_name         = "infy-frontend-subnet1"
    nic_vnet_name           = "infy-vnet"
    nic_pip_name            = "infy-pip-frontend-vm"
    vm_name                 = "infy-frontend-vm"
    vm_size                 = "Standard_F2"
    admin_username          = "devopsadmin"
    admin_password          = "Devops@123"
    os_catching             = "ReadWrite"
    os_storage_account_type = "Standard_LRS"
    image_publisher         = "Canonical"
    image_offer             = "UbuntuServer"
    image_sku               = "16.04-LTS"
    image_version           = "latest"

  }
  nic2 = {
    nic_name                = "nic_backend-vm"
    nic_location            = "centralindia"
    rg_name                 = "infy-rg"
    nic_subnet_name         = "infy-backend-subnet2"
    nic_vnet_name           = "infy-vnet"
    nic_pip_name            = "infy-pip-backend-vm"
    vm_name                 = "infy-backendend-vm"
    vm_size                 = "Standard_F2"
    admin_username          = "devopsadmin"
    admin_password          = "Devops@123"
    os_catching             = "ReadWrite"
    os_storage_account_type = "Standard_LRS"
    image_publisher         = "Canonical"
    image_offer             = "UbuntuServer"
    image_sku               = "16.04-LTS"
    image_version           = "latest"
  }
}