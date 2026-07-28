infy-lab = {
  rg1 = {
    name     = "infy-lab-rg"
    location = "centralindia"
  }

}

infy-lab-vnet = {
  vnet1 = {

    name                = "infy-lab-vnet"
    location            = "centralindia"
    resource_group_name = "infy-lab-rg"
    address_space       = ["10.10.0.0/16"]
  }

}

infy-lab-subnet = {
  subnet1 = {
    name                 = "infy-lab-frontend-subnet1"
    resource_group_name  = "infy-lab-rg"
    virtual_network_name = "infy-lab-vnet"
    address_prefixes     = ["10.10.1.0/24"]
  }

  subnet2 = {
    name                 = "infy-lab-backend-subnet2"
    resource_group_name  = "infy-lab-rg"
    virtual_network_name = "infy-lab-vnet"
    address_prefixes     = ["10.10.2.0/24"]
  }

  subnet3 = {
    name                 = "infy-lab-database-subnet3"
    resource_group_name  = "infy-lab-rg"
    virtual_network_name = "infy-lab-vnet"
    address_prefixes     = ["10.10.3.0/24"]
  }

}

infy-lab-public_ips = {
  pip1 = {
    public_ip_name      = "infy-lab-pip-frontend-vm"
    resource_group_name = "infy-lab-rg"
    location            = "centralindia"
    allocation_method   = "Static"
  }
  pip2 = {
    public_ip_name      = "infy-lab-pip-backend-vm"
    resource_group_name = "infy-lab-rg"
    location            = "centralindia"
    allocation_method   = "Static"
  }
  pip3 = {
    public_ip_name      = "infy-lab-pip-database-vm"
    resource_group_name = "infy-lab-rg"
    location            = "centralindia"
    allocation_method   = "Static"
  }
}

infy-lab-vms = {
  vm1 = {
    nic_name                = "nic_frontend-vm"
    location                = "centralindia"
    rg_name                 = "infy-lab-rg"
    nic_subnet_name         = "infy-lab-frontend-subnet1"
    nic_vnet_name           = "infy-lab-vnet"
    nic_pip_name            = "infy-lab-pip-frontend-vm"
    vm_name                 = "infy-lab-frontend-vm"
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
    rg_name                 = "infy-lab-rg"
    nic_subnet_name         = "infy-lab-backend-subnet2"
    nic_vnet_name           = "infy-lab-vnet"
    nic_pip_name            = "infy-lab-pip-backend-vm"
    vm_name                 = "infy-lab-backendend-vm"
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
    rg_name                 = "infy-lab-rg"
    nic_subnet_name         = "infy-lab-database-subnet3"
    nic_vnet_name           = "infy-lab-vnet"
    nic_pip_name            = "infy-lab-pip-database-vm"
    vm_name                 = "infy-lab-databse-vm"
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