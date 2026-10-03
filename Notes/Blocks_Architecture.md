# Terraform Blocks and Their Types

In Terraform, a **block** is a container used to define configuration. Blocks have a **type**, and some blocks also have **labels**.

## 1. Basic Structure

```hcl
block_type "label1" "label2" {
  argument = value

  nested_block {
    argument = value
  }
}
```

For example:

```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-rg"
  location = "Central India"
}
```

Here:

* `resource` → **block type**
* `azurerm_resource_group` → **first label**
* `example` → **second label**
* `{ ... }` → block body
* `name`, `location` → **arguments**

---

# 2. Main Terraform Block Types

Terraform commonly uses these block types:

| Block       | Purpose                                      | Labels |
| ----------- | -------------------------------------------- | -----: |
| `terraform` | Terraform/backend/provider requirements      |      0 |
| `provider`  | Configure a provider                         |      1 |
| `resource`  | Create/manage infrastructure                 |      2 |
| `data`      | Read existing infrastructure/data            |      2 |
| `variable`  | Define input variables                       |      1 |
| `output`    | Expose values                                |      1 |
| `locals`    | Define local values                          |      0 |
| `module`    | Call a reusable module                       |      1 |
| `moved`     | Tell Terraform about renamed/moved resources |      0 |
| `import`    | Define infrastructure to import              |      0 |
| `check`     | Define assertions/checks                     |      1 |
| `removed`   | Remove resource from Terraform management    |      0 |

---

# 3. `terraform` Block

Defines Terraform-level configuration.

```hcl
terraform {
  required_version = ">= 1.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "lab.tfstate"
  }
}
```

Think:

```text
terraform
   ├── required_version
   ├── required_providers
   └── backend
```

---

# 4. `provider` Block

Configures a provider.

For Azure:

```hcl
provider "azurerm" {
  features {}
}
```

With configuration:

```hcl
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}
```

Structure:

```text
provider
   │
   └── azurerm
```

`azurerm` is the **label**.

---

# 5. `resource` Block

This is one of the most important Terraform blocks.

It defines infrastructure that Terraform will **create/manage**.

```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-rg"
  location = "Central India"
}
```

Structure:

```text
resource
   │
   ├── resource type
   │      azurerm_resource_group
   │
   └── resource name
          example
```

You reference it as:

```hcl
azurerm_resource_group.example.id
```

### Another example

```hcl
resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccount123"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type = "LRS"
}
```

---

# 6. `data` Block

Used to **read existing information** rather than create it.

```hcl
data "azurerm_resource_group" "existing" {
  name = "existing-rg"
}
```

Then:

```hcl
data.azurerm_resource_group.existing.location
```

Important distinction:

```text
resource → Terraform manages/creates infrastructure

data     → Terraform reads existing information
```

---

# 7. `variable` Block

Defines an input variable.

```hcl
variable "location" {
  type        = string
  description = "Azure region"
  default     = "Central India"
}
```

Use it:

```hcl
location = var.location
```

Structure:

```text
variable
   │
   └── location
```

---

# 8. `output` Block

Displays or exposes a value after Terraform execution.

```hcl
output "resource_group_name" {
  value = azurerm_resource_group.example.name
}
```

After:

```bash
terraform apply
```

Terraform can show:

```text
resource_group_name = "my-rg"
```

---

# 9. `locals` Block

Used for reusable calculated/local values.

```hcl
locals {
  environment = "lab"
  project     = "infy"
}
```

Use:

```hcl
name = "${local.project}-${local.environment}-rg"
```

For example:

```text
infy-lab-rg
```

Unlike `variable`, locals are **not inputs supplied by the user**.

---

# 10. `module` Block

Calls a reusable Terraform module.

```hcl
module "network" {
  source = "./modules/network"

  location = var.location
  vnet_name = "lab-vnet"
}
```

Think:

```text
Root module
    │
    ├── network module
    ├── compute module
    └── storage module
```

This becomes very important when you move from small Terraform projects to production infrastructure.

---

# 11. `moved` Block

Used when you rename or move a resource/module without wanting Terraform to destroy and recreate it.

Example:

```hcl
moved {
  from = azurerm_resource_group.old
  to   = azurerm_resource_group.new
}
```

Terraform understands:

```text
old address
    ↓
new address
```

This is especially useful during refactoring.

---

# 12. `import` Block

Used to define infrastructure that should be imported into Terraform state.

Example:

```hcl
import {
  to = azurerm_resource_group.example
  id = "/subscriptions/xxx/resourceGroups/my-rg"
}
```

Conceptually:

```text
Existing Azure resource
        ↓
     import
        ↓
Terraform state
```

---

# 13. `check` Block

Used for Terraform configuration checks/assertions.

Example:

```hcl
check "storage_account_name" {
  data "http" "example" {
    url = "https://example.com"
  }

  assert {
    condition     = data.http.example.status_code == 200
    error_message = "Endpoint is not reachable."
  }
}
```

This is useful for validating assumptions without necessarily making the check a resource dependency.

---

# 14. `removed` Block

Used when you want Terraform to **stop managing** something without destroying the real infrastructure.

Conceptually:

```text
Terraform state
      │
      │ removed
      ↓
Resource no longer managed
      │
      ↓
Actual infrastructure remains
```

This is useful when migrating resources away from Terraform management.

---

# 15. Nested Blocks

A block can contain another block.

For example:

```hcl
resource "azurerm_linux_virtual_machine" "example" {
  name = "my-vm"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
```

Here:

```text
resource
│
├── name = ...
│
└── os_disk        ← nested block
      ├── caching
      └── storage_account_type
```

---

# 16. Block vs Argument

This is **very important**.

### Argument

```hcl
name = "my-rg"
```

`name` is an argument.

### Block

```hcl
os_disk {
  caching = "ReadWrite"
}
```

`os_disk` is a block.

So:

```text
Terraform configuration
│
├── Blocks
│    ├── resource
│    ├── provider
│    ├── variable
│    └── module
│
└── Arguments
     ├── name
     ├── location
     └── type
```

---

# 17. Block Types by Purpose

A useful way to remember them:

```text
Terraform Blocks
│
├── Configuration
│   ├── terraform
│   └── provider
│
├── Infrastructure
│   ├── resource
│   └── data
│
├── Input / Output
│   ├── variable
│   └── output
│
├── Reusability
│   ├── locals
│   └── module
│
├── State / Refactoring
│   ├── moved
│   ├── import
│   └── removed
│
└── Validation
    └── check
```

# Terraform Architecture and Lifecycle

I recommend treating **Terraform Lifecycle** and **Terraform Architecture** as two separate concepts, because lifecycle explains *how Terraform operates*, while architecture explains *what components participate*.

## Recommended structure

```text
terraform/
├── 01-fundamentals/
├── 02-configuration/
├── 03-blocks/
├── 04-lifecycle/
│   ├── README.md
│   ├── init.md
│   ├── validate.md
│   ├── plan.md
│   ├── apply.md
│   ├── refresh.md
│   ├── state.md
│   └── destroy.md
│
└── 05-architecture/
    ├── README.md
    ├── terraform-core.md
    ├── providers.md
    ├── state.md
    ├── configuration.md
    ├── dependency-graph.md
    ├── backend.md
    └── execution-flow.md
```

### Terraform Lifecycle

The core lifecycle should be documented as:

```text
                 Terraform Configuration
                          │
                          ▼
                     terraform init
                          │
                          ▼
                   terraform validate
                          │
                          ▼
                     terraform plan
                          │
                          ▼
                    Review Changes
                          │
                          ▼
                    terraform apply
                          │
                          ▼
                   Infrastructure
                          │
                          ▼
                    Terraform State
                          │
                          ▼
              Configuration changes
                          │
                          └──────────────► plan
                                           │
                                           ▼
                                         apply
```

And when infrastructure is no longer required:

```text
terraform destroy
       │
       ▼
Infrastructure deleted
       │
       ▼
State updated
```

### Architecture

The high-level architecture can be represented as:

```text
                    Terraform CLI
                         │
                         ▼
                 Terraform Core
                  /      |      \
                 /       |       \
                ▼        ▼        ▼
        Configuration   State    Dependency
             │                    Graph
             │
             ▼
          Provider
             │
             ▼
       Provider API
             │
             ▼
     Cloud / Infrastructure
       ┌─────┼─────┐
       ▼     ▼     ▼
     Azure   VM   Storage
```

For your Azure-focused learning, the important flow is:

```text
Terraform Configuration
        │
        ▼
Terraform Core
        │
        ▼
AzureRM Provider
        │
        ▼
Azure API
        │
        ▼
Azure Resources
```

**Important distinction:** Terraform itself does not directly create an Azure VM, VNet, Storage Account, etc. **Terraform Core communicates through the AzureRM provider**, and the provider communicates with Azure APIs.

