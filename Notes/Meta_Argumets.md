# /conceptinside — Azure Terraform Meta-Arguments

Meta-arguments are **special Terraform keywords** that control **how resources and modules are created, managed, or destroyed**. They are **not Azure-specific**—they work with all Terraform providers (Azure, AWS, GCP, etc.).

> **Think of it like this:**
>
> * **Arguments** = *What* to create (VM size, location, name)
> * **Meta-arguments** = *How* Terraform should create or manage it

---

# Why Meta-Arguments?

Without meta-arguments:

* Resources are created one by one based only on detected dependencies.
* You cannot easily create multiple similar resources.
* You cannot control lifecycle behavior.
* You cannot force dependencies.

With meta-arguments, you can:

* Create multiple Azure resources automatically.
* Control deployment order.
* Prevent accidental deletion.
* Ignore changes made outside Terraform.
* Replace resources safely.

---

# Azure Example

Without meta-arguments:

```terraform
resource "azurerm_resource_group" "rg1" {
  name     = "dev-rg"
  location = "Central India"
}

resource "azurerm_resource_group" "rg2" {
  name     = "test-rg"
  location = "Central India"
}

resource "azurerm_resource_group" "rg3" {
  name     = "prod-rg"
  location = "Central India"
}
```

Lots of duplicate code.

Using **count**:

```terraform
resource "azurerm_resource_group" "rg" {
  count = 3

  name     = "rg-${count.index}"
  location = "Central India"
}
```

Terraform creates:

```
rg-0
rg-1
rg-2
```

---

# Terraform Meta-Arguments

| Meta-Argument                              | Purpose                                                                                                    |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------- |
| count                                      | Create multiple identical resources                                                                        |
| for_each                                   | Create multiple unique resources                                                                           |
| depends_on                                 | Explicit dependency                                                                                        |
| lifecycle                                  | Control create/update/delete behavior                                                                      |
| provider                                   | Use a specific provider configuration                                                                      |
| providers                                  | Pass providers to child modules                                                                            |
| action_trigger *(newer Terraform feature)* | Trigger custom actions during resource lifecycle (supported only by providers/resources that implement it) |
| count / for_each (module)                  | Create multiple module instances                                                                           |

---

# 1. count

Creates multiple copies of a resource.

Example:

```terraform
resource "azurerm_resource_group" "rg" {
  count = 3

  name     = "rg-${count.index}"
  location = "Central India"
}
```

Result:

```
rg-0
rg-1
rg-2
```

### Access

```terraform
azurerm_resource_group.rg[0]
azurerm_resource_group.rg[1]
```

---

## Real Azure Scenario

Create three Storage Accounts.

```terraform
resource "azurerm_storage_account" "storage" {
  count = 3

  name                     = "storage${count.index}12345"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

---

# 2. for_each

Best when every resource has a different name or configuration.

```terraform
locals {
  rgs = {
    dev  = "Central India"
    test = "East US"
    prod = "West Europe"
  }
}

resource "azurerm_resource_group" "rg" {
  for_each = local.rgs

  name     = each.key
  location = each.value
}
```

Creates:

```
dev
test
prod
```

---

## Access

```terraform
azurerm_resource_group.rg["dev"]
```

---

## count vs for_each

| count                                | for_each                                  |
| ------------------------------------ | ----------------------------------------- |
| Uses index                           | Uses key                                  |
| Better for identical resources       | Better for unique resources               |
| Index changes can recreate resources | Stable keys reduce unnecessary recreation |
| Uses count.index                     | Uses each.key / each.value                |

---

# 3. depends_on

Terraform usually detects dependencies automatically.

Example:

```terraform
resource_group_name = azurerm_resource_group.rg.name
```

Terraform knows:

```
RG
 ↓
Storage Account
```

Sometimes there is **no direct reference**.

Then use:

```terraform
depends_on = [
  azurerm_resource_group.rg
]
```

Example:

```terraform
resource "azurerm_storage_account" "storage" {

  depends_on = [
    azurerm_resource_group.rg
  ]

  name                     = "myterraformstorage"
  location                 = "Central India"
  resource_group_name      = azurerm_resource_group.rg.name
}
```

---

## Real Scenario

Azure VM Extension must wait for VM creation.

```
Virtual Machine
      ↓
VM Extension
```

Use:

```terraform
depends_on = [
    azurerm_linux_virtual_machine.vm
]
```

---

# 4. lifecycle

Controls how Terraform manages resources.

Syntax:

```terraform
lifecycle {

}
```

Contains:

* create_before_destroy
* prevent_destroy
* ignore_changes
* replace_triggered_by

---

## create_before_destroy

Default behavior:

```
Delete Old VM
      ↓
Create New VM
```

Downtime occurs.

Using:

```terraform
lifecycle {
  create_before_destroy = true
}
```

Flow:

```
Create New VM
      ↓
Delete Old VM
```

No downtime (when Azure resource constraints allow).

---

## prevent_destroy

Protects critical resources.

```terraform
lifecycle {

  prevent_destroy = true

}
```

Trying:

```
terraform destroy
```

Result:

```
Error

Resource is protected.
```

Useful for:

* Production Database
* Storage Account
* Key Vault

---

## ignore_changes

Azure administrators may change tags or settings in the Azure Portal.

Terraform normally tries to revert those changes.

Example:

Portal:

```
Tag = Owner=Admin
```

Terraform:

```
Owner=DevOps
```

Terraform wants to overwrite.

Ignore it:

```terraform
lifecycle {

  ignore_changes = [
      tags
  ]

}
```

Terraform ignores tag drift.

---

## replace_triggered_by

Force replacement when another resource changes.

Example:

```terraform
lifecycle {

  replace_triggered_by = [
      azurerm_virtual_network.vnet
  ]

}
```

---

# 5. provider

Use multiple Azure subscriptions.

Example providers:

```terraform
provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "prod"
  subscription_id = "xxxxxxxx"
  features {}
}
```

Resource:

```terraform
resource "azurerm_resource_group" "prod" {

  provider = azurerm.prod

  name     = "prod-rg"
  location = "Central India"
}
```

Useful for:

* Dev Subscription
* Test Subscription
* Production Subscription

---

# 6. providers (Module Meta-Argument)

When calling a child module, pass a specific provider configuration.

```terraform
module "network" {
  source = "./modules/network"

  providers = {
    azurerm = azurerm.prod
  }
}
```

---

# 7. action_trigger *(provider support required)*

Allows a provider/resource to run a custom action during lifecycle events if that provider implements support for it.

Example (conceptual):

```terraform
resource "example_resource" "demo" {
  # resource configuration

  action_trigger {
    # provider-specific action
  }
}
```

> Availability depends on the provider. Many Azure resources do **not** currently use this feature.

---

# Meta-Arguments in Modules

`count`

```terraform
module "rg" {
  source = "./modules/rg"

  count = 3
}
```

---

`for_each`

```terraform
module "storage" {

  source = "./modules/storage"

  for_each = {
    dev  = "Central India"
    prod = "East US"
  }
}
```

---

# Azure DevOps Interview Questions

### Q1. What are Terraform meta-arguments?

Special keywords that control **how Terraform creates, manages, or destroys resources**, rather than defining the resource itself.

---

### Q2. Difference between `count` and `for_each`?

* **count** → Best for multiple identical resources, accessed by index.
* **for_each** → Best for unique resources, accessed by key.

---

### Q3. When do you use `depends_on`?

When Terraform **cannot automatically detect a dependency**, but one resource must be created after another.

---

### Q4. What is the difference between implicit and explicit dependency?

* **Implicit dependency**: Created automatically through resource references.
* **Explicit dependency**: Defined manually using `depends_on`.

---

### Q5. Why use `prevent_destroy`?

To protect critical Azure resources (like production databases or Key Vaults) from accidental deletion.

---

### Q6. Why use `ignore_changes`?

To prevent Terraform from reverting changes made outside Terraform (for example, tags or settings updated in the Azure Portal).

---

### Q7. When would you use the `provider` meta-argument?

When deploying resources to different Azure subscriptions or using different provider configurations (such as separate dev and production environments).

---

# Quick Revision

| Meta-Argument                     | Interview Keyword                  | Azure Example                                           |
| --------------------------------- | ---------------------------------- | ------------------------------------------------------- |
| `count`                           | Multiple identical resources       | Create 3 Resource Groups                                |
| `for_each`                        | Multiple unique resources          | Dev/Test/Prod Resource Groups                           |
| `depends_on`                      | Explicit dependency                | VM → VM Extension                                       |
| `lifecycle.create_before_destroy` | Zero/minimal downtime replacement  | Replace VM with minimal interruption                    |
| `lifecycle.prevent_destroy`       | Resource protection                | Production Key Vault                                    |
| `lifecycle.ignore_changes`        | Ignore configuration drift         | Portal tag updates                                      |
| `lifecycle.replace_triggered_by`  | Force replacement                  | Recreate dependent resource after VNet change           |
| `provider`                        | Multiple provider configurations   | Deploy to different Azure subscriptions                 |
| `providers`                       | Pass provider to child module      | Module uses production subscription                     |
| `action_trigger`                  | Provider-specific lifecycle action | Supported only by providers/resources that implement it |

> **Interview tip:** The most commonly used Terraform meta-arguments in Azure projects are **`count`**, **`for_each`**, **`depends_on`**, **`lifecycle`**, and **`provider`**. Understanding when to use each—and the difference between implicit and explicit dependencies—is a frequent focus in DevOps interviews.
