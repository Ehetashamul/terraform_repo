infy-VM = {
  infy-vm1 = {
    name                  = "infy-vm1"
    location              = "centralindia"
    resource_group_name   = "infy-rg1"
    network_interface_ids = ["/subscriptions/7a04619b-86b3-4bc8-8b52-8168bd785f0b/resourceGroups/infy-rg1/providers/Microsoft.Network/networkInterfaces/infy-NIC1"]
    vm_size               = "Standard_D2s_v3"


    storage_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
    storage_os_disk = {
      name              = "myosdisk1"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }
    os_profile = {
      computer_name  = "infy-admin"
      admin_username = "testadmin"
      admin_password = "Admin@1234"
    }
  }

  infy-vm2 = {
    name                  = "infy-vm2"
    location              = "centralindia"
    resource_group_name   = "infy-rg1"
    network_interface_ids = ["/subscriptions/7a04619b-86b3-4bc8-8b52-8168bd785f0b/resourceGroups/infy-rg1/providers/Microsoft.Network/networkInterfaces/infy-NIC2"]
    vm_size               = "Standard_D2s_v3"


    storage_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-Datacenter"
      version   = "latest"
    }
    storage_os_disk = {
      name              = "myosdisk2"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }
    os_profile = {
      computer_name  = "infy-admin"
      admin_username = "testadmin"
      admin_password = "Admin@1234"
    }
  }
}