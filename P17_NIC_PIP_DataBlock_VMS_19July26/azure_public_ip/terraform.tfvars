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