resource "azurerm_resource_group" "infy-rg" {
  for_each = var.infy

  name     = each.value.name
  location = each.value.location
}

