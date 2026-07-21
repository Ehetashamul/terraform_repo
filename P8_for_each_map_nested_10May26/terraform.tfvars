# here i have created rg-700 and rg-7001 manually

storage_account = {
  sa1 = {
    name                     = "stora17101"
    resource_group_name      = "rg-700"
    location                 = "West US"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }

  sa2 = {
    name                     = "stor17101"
    resource_group_name      = "rg-701"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "LRS"

  }
}

