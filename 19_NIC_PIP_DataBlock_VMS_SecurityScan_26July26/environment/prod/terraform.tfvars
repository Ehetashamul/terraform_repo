infy-prod = {
  rg1 = {
    name     = "infy-prod-rg"
    location = "centralindia"
  }

}

infy-prod-vnet = {
  vnet1 = {

    name                = "infy-prod-vnet"
    location            = "centralindia"
    resource_group_name = "infy-prod-rg"
    address_space       = ["10.10.0.0/16"]
  }

}

infy-prod-subnet = {
  subnet1 = {
    name                 = "infy-prod-frontend-subnet1"
    resource_group_name  = "infy-prod-rg"
    virtual_network_name = "infy-prod-vnet"
    address_prefixes     = ["10.10.1.0/24"]
  }

  subnet2 = {
    name                 = "infy-prod-backend-subnet2"
    resource_group_name  = "infy-prod-rg"
    virtual_network_name = "infy-prod-vnet"
    address_prefixes     = ["10.10.2.0/24"]
  }

  subnet3 = {
    name                 = "infy-prod-database-subnet3"
    resource_group_name  = "infy-prod-rg"
    virtual_network_name = "infy-prod-vnet"
    address_prefixes     = ["10.10.3.0/24"]
  }

}

infy-prod-public_ips = {
  pip1 = {
    public_ip_name      = "infy-prod-pip-frontend-vm"
    resource_group_name = "infy-prod-rg"
    location            = "centralindia"
    allocation_method   = "Static"
  }
  pip2 = {
    public_ip_name      = "infy-prod-pip-backend-vm"
    resource_group_name = "infy-prod-rg"
    location            = "centralindia"
    allocation_method   = "Static"
  }
  pip3 = {
    public_ip_name      = "infy-prod-pip-database-vm"
    resource_group_name = "infy-prod-rg"
    location            = "centralindia"
    allocation_method   = "Static"
  }
}

infy-prod-vms = {
  vm1 = {
    nic_name                = "nic_frontend-vm"
    location                = "centralindia"
    rg_name                 = "infy-prod-rg"
    nic_subnet_name         = "infy-prod-frontend-subnet1"
    nic_vnet_name           = "infy-prod-vnet"
    nic_pip_name            = "infy-prod-pip-frontend-vm"
    vm_name                 = "infy-prod-frontend-vm"
    vm_size                 = "Standard_D2s_v3"
    admin_username          = "devopsadmin"
    admin_password          = "Devops@123"
    os_caching              = "ReadWrite"
    os_storage_account_type = "Standard_LRS"
    image_publisher         = "Canonical"
    image_offer             = "0001-com-ubuntu-server-jammy"
    image_sku               = "22_04-lts"
    image_version           = "latest"

  }
  vm2 = {
    nic_name                = "nic_backend-vm"
    location                = "centralindia"
    rg_name                 = "infy-prod-rg"
    nic_subnet_name         = "infy-prod-backend-subnet2"
    nic_vnet_name           = "infy-prod-vnet"
    nic_pip_name            = "infy-prod-pip-backend-vm"
    vm_name                 = "infy-prod-backendend-vm"
    vm_size                 = "Standard_D2s_v3"
    admin_username          = "devopsadmin"
    admin_password          = "Devops@123"
    os_caching              = "ReadWrite"
    os_storage_account_type = "Standard_LRS"
    image_publisher         = "Canonical"
    image_offer             = "0001-com-ubuntu-server-jammy"
    image_sku               = "22_04-lts"
    image_version           = "latest"
  }
  vm3 = {
    nic_name                = "nic_databse-vm"
    location                = "centralindia"
    rg_name                 = "infy-prod-rg"
    nic_subnet_name         = "infy-prod-database-subnet3"
    nic_vnet_name           = "infy-prod-vnet"
    nic_pip_name            = "infy-prod-pip-database-vm"
    vm_name                 = "infy-prod-databse-vm"
    vm_size                 = "Standard_D2s_v3"
    admin_username          = "devopsadmin"
    admin_password          = "Devops@123"
    os_caching              = "ReadWrite"
    os_storage_account_type = "Standard_LRS"
    image_publisher         = "Canonical"
    image_offer             = "0001-com-ubuntu-server-jammy"
    image_sku               = "22_04-lts"
    image_version           = "latest"
  }
}