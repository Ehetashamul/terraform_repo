# Terraform Modules — Complete Concept (Zero Confusion Version)

Terraform Modules are one of the **most important Terraform concepts**. If you understand modules well, you'll write cleaner, reusable, and production-ready Infrastructure as Code (IaC), and you'll be able to answer many DevOps interview questions confidently.

---

# First Understand the Problem

Imagine you're building infrastructure for three environments:

* Development
* Testing (QA)
* Production

Each environment needs:

* Virtual Network (VNet)
* Subnets
* Network Security Groups (NSGs)
* Storage Account
* Virtual Machine

Without modules, you'd end up copying and pasting the same Terraform code into multiple folders.

```
dev/
    main.tf

qa/
    main.tf

prod/
    main.tf
```

Each file might contain **300–500 lines** of nearly identical code.

Problems:

* Lots of duplicate code
* Hard to maintain
* Easy to introduce mistakes
* Updating one resource means editing multiple files

Terraform Modules solve this.

---

# What is a Terraform Module?

A **Terraform Module** is simply a collection of Terraform configuration files (`.tf`) stored in a directory that work together to create a specific piece of infrastructure.

Think of a module as a reusable blueprint.

Instead of writing infrastructure repeatedly, you write it **once** and reuse it everywhere.

```
Module
│
├── main.tf
├── variables.tf
├── outputs.tf
└── versions.tf
```

Terraform itself considers **every folder containing `.tf` files** to be a module.

---

# Real-Life Analogy

Imagine you're building apartments.

Without modules:

Every apartment is designed from scratch.

```
Engineer
↓

Draw Apartment 1

↓

Draw Apartment 2

↓

Draw Apartment 3
```

Huge amount of repetitive work.

With modules:

```
Blueprint
↓

Apartment A

↓

Apartment B

↓

Apartment C
```

One blueprint builds many apartments.

Terraform Modules work exactly like architectural blueprints.

---

# Types of Modules

Terraform has two primary module types.

---

## 1. Root Module

The folder where you run Terraform commands is called the **Root Module**.

Example:

```
terraform init
terraform plan
terraform apply
```

Suppose your project is:

```
project/

    main.tf
    variables.tf
    outputs.tf
```

When you execute:

```
terraform apply
```

Terraform treats this folder as the Root Module.

It is the **entry point** of execution.

---

## 2. Child Module

A Child Module is a module that is called from another module.

Example:

```
module "network" {
  source = "./modules/network"

  resource_group_name = "rg-dev"
  location            = "Central India"
}
```

Terraform reads the module stored inside:

```
modules/network
```

and creates the resources defined there.

---

# Where Can Child Modules Be Stored?

Terraform supports multiple module sources.

### Local Module

```
source = "./modules/network"
```

Project structure:

```
project

│
├── main.tf
│
└── modules
      └── network
```

Best for:

* Small projects
* Learning
* Internal development

---

### GitHub Module

```
source = "git::https://github.com/company/network-module.git"
```

Useful when multiple teams share infrastructure.

---

### Azure DevOps Repos

```
source = "git::https://dev.azure.com/company/project/_git/network"
```

Common in enterprise environments.

---

### Terraform Registry

Example:

```
source = "Azure/network/azurerm"
```

Public modules maintained by the Terraform community or vendors.

---

### Private Module Registry

Many organizations maintain an internal registry containing approved modules.

Benefits:

* Security
* Governance
* Version control
* Standardization

---

# Typical Module Structure

```
network-module/

│
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
└── README.md
```

---

## main.tf

Contains the resources.

Example:

```
resource "azurerm_virtual_network" "vnet" {

}
```

---

## variables.tf

Defines inputs.

Example:

```
variable "vnet_name" {}

variable "location" {}

variable "address_space" {}
```

---

## outputs.tf

Returns useful information.

Example:

```
output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}
```

---

## versions.tf

Defines Terraform and provider versions.

Example:

```
terraform {

  required_version = ">=1.5"

  required_providers {

    azurerm = {

      source = "hashicorp/azurerm"

      version = "~>4.0"

    }

  }

}
```

---

# How Does a Module Work?

```
Root Module

│

│ Calls

↓

Network Module

│

│ Creates

↓

Azure Virtual Network

↓

Subnets

↓

NSG

↓

Route Tables

↓

Outputs VNet ID

↓

Root Module Uses Output
```

---

# Why Do We Use Terraform Modules?

Modules solve several real-world Infrastructure as Code (IaC) challenges.

---

## 1. Reusability

Instead of writing the same Terraform code repeatedly, create it once and reuse it across projects.

Example:

One VNet module can provision:

* Dev VNet
* QA VNet
* UAT VNet
* Production VNet

Only the input values change.

```
module "dev" {

 source = "./modules/network"

 name = "dev-vnet"

}
```

```
module "prod" {

 source = "./modules/network"

 name = "prod-vnet"

}
```

Same code.

Different infrastructure.

---

## 2. Consistency

Modules ensure every deployment follows the same standards.

Examples:

* Naming conventions
* Required tags
* NSG rules
* Security settings
* Diagnostic logs
* Monitoring configuration

Without modules:

Different engineers may build resources differently.

With modules:

Everything follows the same approved design.

This greatly reduces **configuration drift**.

---

## 3. Collaboration

Modules allow teams to share proven infrastructure code.

Examples:

Platform Team

Creates:

```
Storage Module
```

Application Team

Simply uses it:

```
module "storage" {

 source = "company/storage"

}
```

No need to reinvent the wheel.

---

## 4. Productivity

Developers no longer create infrastructure from scratch.

Instead, they call an existing module:

```
module "vm" {

 source = "./modules/vm"

 vm_name = "app01"

}
```

Terraform creates:

* VM
* NIC
* Public IP
* Managed Disk
* Diagnostics
* NSG

using standardized code.

---

## 5. Easier Maintenance

Imagine your organization has **50 projects**.

Each project creates a Storage Account.

Microsoft introduces a new security requirement.

Without modules:

You update 50 different Terraform files.

With modules:

You update the module once.

Every project benefits after updating the module version.

---

## 6. Version Control

Modules can be versioned.

Example:

```
source  = "Azure/network/azurerm"
version = "4.2.0"
```

Benefits:

* Stable deployments
* Rollback support
* Predictable behavior

---

# Module Inputs and Outputs

Modules communicate using **input variables** and **outputs**.

```
Root Module

↓

Inputs

↓

Child Module

↓

Creates Resources

↓

Outputs

↓

Root Module
```

Example:

```
module "network" {

 source = "./modules/network"

 vnet_name = "dev-vnet"

}
```

Module output:

```
output "vnet_id" {

 value = azurerm_virtual_network.vnet.id

}
```

Root module uses it:

```
module.network.vnet_id
```

---

# Module Execution Flow

```
terraform apply

↓

Read Root Module

↓

Find Module Blocks

↓

Download Modules
(Local/GitHub/Registry)

↓

Read Variables

↓

Create Resources

↓

Generate Outputs

↓

Save State
```

---

# Best Practices

* Design each module for a **single responsibility** (e.g., one module for networking, another for storage).
* Expose only the necessary input variables and outputs.
* Keep provider configuration in the **root module** unless there is a specific reason otherwise.
* Version shared modules and pin versions in production.
* Document each module with a `README.md`.
* Avoid hard-coded values; use variables instead.
* Use consistent naming, tagging, and folder structures across modules.

---

# Advantages

| Feature         | Benefit                                     |
| --------------- | ------------------------------------------- |
| Reusability     | Write once, use many times                  |
| Consistency     | Standard infrastructure across environments |
| Maintainability | Update one module instead of many files     |
| Collaboration   | Teams share common infrastructure code      |
| Scalability     | Easy to manage large environments           |
| Productivity    | Faster infrastructure deployment            |
| Versioning      | Stable and repeatable deployments           |

---

# Interview Questions

### Q1. What is a Terraform Module?

A Terraform module is a reusable collection of `.tf` files that work together to provision and manage infrastructure.

### Q2. What is the difference between a Root Module and a Child Module?

| Root Module                        | Child Module                   |
| ---------------------------------- | ------------------------------ |
| Entry point of Terraform execution | Called by another module       |
| Current working directory          | Separate reusable directory    |
| Executed directly                  | Invoked using a `module` block |

### Q3. Why should we use Terraform Modules instead of copying code?

Modules improve reusability, consistency, maintainability, collaboration, and reduce duplication and configuration drift.

### Q4. What files are commonly found in a Terraform module?

`main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, and often `README.md`.

### Q5. How do modules communicate?

Through **input variables** (data passed into the module) and **outputs** (values returned by the module).

### Q6. Where can Terraform modules be stored?

* Local directories
* Terraform Registry
* GitHub
* Azure DevOps Repos
* Private module registries

### Q7. Can one module call another module?

Yes. A child module can itself call other child modules, creating a nested module hierarchy for complex infrastructures.

---

## Key Takeaway

A Terraform module is a **reusable, versionable, and maintainable building block** for Infrastructure as Code. Rather than duplicating Terraform code across environments, you encapsulate related resources into modules and reuse them through the root module. This leads to standardized, scalable, and easier-to-manage infrastructure, making modules a foundational practice in production-grade Terraform deployments.
