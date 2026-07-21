resource "azurerm_resource_group" "resource_group_name" {
   
   #for_each = {
    #rg1 = "Central India"
    #rg2 = "East US"
    # }
    for_each = var.resource_group_name
    name = each.key
    location = each.value
  
}