variable "resource_groups" {
  type = list(string)
  default = ["rg-test100", "rg-test101", "rg-test102", "rg-test103", "rg-test104"]
  description = "List of resource groups Name"
}

