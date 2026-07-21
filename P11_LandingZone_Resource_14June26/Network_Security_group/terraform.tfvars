infy-NSG = {
  infy-NSG1 = {
    name                = "infyTestSecurityGroup1"
    location            = "centralindia"
    resource_group_name = "infy-rg1"


    security_rule = {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  infy-NSG2 = {
    name                = "infyTestSecurityGroup2"
    location            = "centralindia"
    resource_group_name = "infy-rg1"


    security_rule = {
      name                       = "RDP"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}