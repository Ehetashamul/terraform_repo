variable "resource_group_name" {
  type = map(string)
  default = {
    prod = "Central India"
    lab = "East US"
  }
}