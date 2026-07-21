infy = {
  rg1 = {
    name     = "infy-rg"
    location = "centralindia"
  }

}

infy-vnet = {
  vnet1 = {

    name                = "infy-vnet"
    location            = "centralindia"
    resource_group_name = "infy-rg"
    address_space       = ["10.10.0.0/16"]
  }

}

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

public_ips = {
  pip1 = {
    public_ip_name      = "infy-pip-frontend-vm"
    resource_group_name = "infy-rg"
    location            = "centralindia"
    allocation_method   = "Static"
  }
  pip2 = {
    public_ip_name      = "infy-pip-backend-vm"
    resource_group_name = "infy-rg"
    location            = "centralindia"
    allocation_method   = "Static"
  }
}

vms = {
  nic1 = {
    nic_name                = "nic_frontend-vm"
    location                = "centralindia"
    rg_name                 = "infy-rg"
    nic_subnet_name         = "infy-frontend-subnet1"
    nic_vnet_name           = "infy-vnet"
    nic_pip_name            = "infy-pip-frontend-vm"
    vm_name                 = "infy-frontend-vm"
    vm_size                 = "Standard_D2s_v3"
    admin_username          = "devopsadmin"
    admin_password          = "Devops@123"
    os_caching             = "ReadWrite"
    os_storage_account_type = "Standard_LRS"
    image_publisher         = "Canonical"
    image_offer             = "0001-com-ubuntu-server-jammy"
    image_sku               = "22_04-lts"
    image_version           = "latest"

  }
  nic2 = {
    nic_name                = "nic_backend-vm"
    location            = "centralindia"
    rg_name                 = "infy-rg"
    nic_subnet_name         = "infy-backend-subnet2"
    nic_vnet_name           = "infy-vnet"
    nic_pip_name            = "infy-pip-backend-vm"
    vm_name                 = "infy-backendend-vm"
    vm_size                 = "Standard_D2s_v3"
    admin_username          = "devopsadmin"
    admin_password          = "Devops@123"
    os_caching             = "ReadWrite"
    os_storage_account_type = "Standard_LRS"
    image_publisher         = "Canonical"
    image_offer             = "0001-com-ubuntu-server-jammy"
    image_sku               = "22_04-lts"
    image_version           = "latest"
  }
}