rgs = {
  rg1 = {
    name     = "rg-chor-prod"
    location = "centralindia"
  }
}

vnets = {
  vnet1 = {
    name                = "vnet-chor-prod"
    location            = "centralindia"
    resource_group_name = "rg-chor-prod"
    address_space       = ["10.0.0.0/16"]
  }
}

subnets = {
  snet1 = {
    name                 = "frontend-subnet-prod"
    resource_group_name  = "rg-chor-prod"
    virtual_network_name = "vnet-chor-prod"
    address_prefixes     = ["10.0.1.0/24"]
  }
  snet2 = {
    name                 = "backend-subnet-prod"
    resource_group_name  = "rg-chor-prod"
    virtual_network_name = "vnet-chor-prod"
    address_prefixes     = ["10.0.2.0/24"]
  }
  snet3 = {
    name                 = "database-subnet-prod"
    resource_group_name  = "rg-chor-prod"
    virtual_network_name = "vnet-chor-prod"
    address_prefixes     = ["10.0.3.0/24"]
  }
  snet4 = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "rg-chor-prod"
    virtual_network_name = "vnet-chor-prod"
    address_prefixes     = ["10.0.4.0/26"]
  }
  snet5 = {
    name                 = "AppGatewaySubnet"
    resource_group_name  = "rg-chor-prod"
    virtual_network_name = "vnet-chor-prod"
    address_prefixes     = ["10.0.5.0/24"]
  }
}

public_ips = {
  pip_bastion = {
    public_ip_name      = "pip-bastion-prod"
    resource_group_name = "rg-chor-prod"
    location            = "centralindia"
    allocation_method   = "Static"
  }
  pip_appgw = {
    public_ip_name      = "pip-appgw-prod"
    resource_group_name = "rg-chor-prod"
    location            = "centralindia"
    allocation_method   = "Static"
  }
}

vms = {
  frontend_1 = {
    nic_name        = "frontend-vm-nic-1-prod"
    location        = "centralindia"
    rg_name         = "rg-chor-prod"
    nic_subnet_name = "frontend-subnet-prod"
    nic_vnet_name   = "vnet-chor-prod"
    vm_name         = "frontend-vm-1-prod"
    vm_size         = "Standard_B1s"
    admin_username  = "devopsadmin"
    key_vault_name  = "kv-chor-prod-123"
    secret_name     = "admin-password"
    image_publisher = "Canonical"
    image_offer     = "0001-com-ubuntu-server-jammy"
    image_sku       = "22_04-lts"
    image_version   = "latest"
  }
  frontend_2 = {
    nic_name        = "frontend-vm-nic-2-prod"
    location        = "centralindia"
    rg_name         = "rg-chor-prod"
    nic_subnet_name = "frontend-subnet-prod"
    nic_vnet_name   = "vnet-chor-prod"
    vm_name         = "frontend-vm-2-prod"
    vm_size         = "Standard_B1s"
    admin_username  = "devopsadmin"
    key_vault_name  = "kv-chor-prod-123"
    secret_name     = "admin-password"
    image_publisher = "Canonical"
    image_offer     = "0001-com-ubuntu-server-jammy"
    image_sku       = "22_04-lts"
    image_version   = "latest"
  }
  backend_1 = {
    nic_name        = "backend-vm-nic-1-prod"
    location        = "centralindia"
    rg_name         = "rg-chor-prod"
    nic_subnet_name = "backend-subnet-prod"
    nic_vnet_name   = "vnet-chor-prod"
    vm_name         = "backend-vm-1-prod"
    vm_size         = "Standard_B1s"
    admin_username  = "devopsadmin"
    key_vault_name  = "kv-chor-prod-123"
    secret_name     = "admin-password"
    image_publisher = "Canonical"
    image_offer     = "0001-com-ubuntu-server-jammy"
    image_sku       = "22_04-lts"
    image_version   = "latest"
  }
  backend_2 = {
    nic_name        = "backend-vm-nic-2-prod"
    location        = "centralindia"
    rg_name         = "rg-chor-prod"
    nic_subnet_name = "backend-subnet-prod"
    nic_vnet_name   = "vnet-chor-prod"
    vm_name         = "backend-vm-2-prod"
    vm_size         = "Standard_B1s"
    admin_username  = "devopsadmin"
    key_vault_name  = "kv-chor-prod-123"
    secret_name     = "admin-password"
    image_publisher = "Canonical"
    image_offer     = "0001-com-ubuntu-server-jammy"
    image_sku       = "22_04-lts"
    image_version   = "latest"
  }
  database_1 = {
    nic_name        = "database-vm-nic-prod"
    location        = "centralindia"
    rg_name         = "rg-chor-prod"
    nic_subnet_name = "database-subnet-prod"
    nic_vnet_name   = "vnet-chor-prod"
    vm_name         = "database-vm-prod"
    vm_size         = "Standard_B2s"
    admin_username  = "devopsadmin"
    key_vault_name  = "kv-chor-prod-123"
    secret_name     = "admin-password"
    image_publisher = "Canonical"
    image_offer     = "0001-com-ubuntu-server-jammy"
    image_sku       = "22_04-lts"
    image_version   = "latest"
  }
}

bastions = {
  bastion1 = {
    name           = "bastion-prod"
    location       = "centralindia"
    rg_name        = "rg-chor-prod"
    subnet_name    = "AzureBastionSubnet"
    vnet_name      = "vnet-chor-prod"
    public_ip_name = "pip-bastion-prod"
  }
}

app_gateways = {
  appgw1 = {
    name           = "appgw-prod"
    location       = "centralindia"
    rg_name        = "rg-chor-prod"
    subnet_name    = "AppGatewaySubnet"
    vnet_name      = "vnet-chor-prod"
    public_ip_name = "pip-appgw-prod"
  }
}

load_balancers = {
  lb1 = {
    name        = "lb-backend-prod"
    location    = "centralindia"
    rg_name     = "rg-chor-prod"
    subnet_name = "backend-subnet-prod"
    vnet_name   = "vnet-chor-prod"
  }
}

key_vaults = {
  kv1 = {
    name        = "kv-chor-prod-123"
    location    = "centralindia"
    rg_name     = "rg-chor-prod"
    secret_name = "admin-password"
  }
}