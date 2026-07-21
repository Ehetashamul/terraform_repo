resource "azurerm_network_interface" "nic" {
  for_each            = var.nics
  name                = each.value.nic_name
  location            = each.value.nic_location
  resource_group_name = each.value.nic_rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.nic_subnet_id
    public_ip_address_id          = each.value.nic_pip_id
    private_ip_address_allocation = "Dynamic"
  }
}