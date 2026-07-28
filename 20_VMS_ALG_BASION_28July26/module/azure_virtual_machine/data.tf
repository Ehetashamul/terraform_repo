data "azurerm_subnet" "subnet" {
  for_each             = var.vms
  name                 = each.value.nic_subnet_name
  virtual_network_name = each.value.nic_vnet_name
  resource_group_name  = each.value.rg_name
}

data "azurerm_public_ip" "public_ip" {
  for_each            = var.vms
  name                = each.value.nic_pip_name
  resource_group_name = each.value.rg_name
}