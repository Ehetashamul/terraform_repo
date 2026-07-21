
resource "azurerm_resource_group" "rg" {
  # when we do not declared variables.tf and terraform.tfvars then we can use as below
  #for_each = toset( ["rg-test201", "rg-test202", "rg-test203", "rg-test204", "rg-test205"])
  
  for_each = toset(var.resource_groups)

  name     = each.value    # we can add each.key as well for list
  location = "Central India"
}
