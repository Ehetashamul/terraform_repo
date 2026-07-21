variable "resource_group_name" {
  type        = string
  default     = "rg-test1"
  description = "Name Of Resource Group"
}

variable "storage_account_name" {
  type        = string
  default     = "storagetest1"
  description = "Globally Unique Storage Account Name "
}

variable "location" {
  type        = string
  default     = "Central India"
  description = "Azure Region"
}