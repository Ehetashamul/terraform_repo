# Terraform State File

## 1. What is Terraform State?

Terraform State is a persistent record maintained by Terraform that keeps track of the infrastructure Terraform manages.

The default local state file is:

```text
terraform.tfstate
```

The state provides the mapping between:

```text
Terraform Configuration
        ↓
Terraform State
        ↓
Real Infrastructure
```

For example, Terraform configuration may contain:

```hcl
resource "azurerm_resource_group" "app" {
  name     = "rg-app"
  location = "East US"
}
```

After Terraform creates the resource, the state keeps information that connects:

```text
azurerm_resource_group.app
        ↓
Azure Resource Group
        ↓
/subscriptions/.../resourceGroups/rg-app
```

Therefore, the most important thing to remember is:

> **Terraform state maps Terraform resource addresses to real infrastructure and stores the information Terraform needs to manage changes.**

---

# 2. Why Does Terraform Need State?

Terraform is declarative.

You describe:

```text
What you want
```

rather than:

```text
How to create it step-by-step
```

Terraform therefore needs to determine the difference between:

```text
Desired State
        vs
Current Infrastructure
```

State helps Terraform maintain this relationship.

Without state, Terraform would not have Terraform's persistent record of which real resources correspond to which resources in the configuration.

For example:

```text
main.tf

azurerm_resource_group.app
```

State can associate this Terraform resource with:

```text
Azure Resource Group
rg-app
/subscriptions/.../resourceGroups/rg-app
```

---

# 3. The Three Important States

When learning Terraform, distinguish these three concepts:

```text
1. Configuration
2. State
3. Real Infrastructure
```

### Configuration

Your `.tf` files define the desired infrastructure.

```hcl
resource "azurerm_resource_group" "app" {
  name     = "rg-app"
  location = "East US"
}
```

### State

Terraform records what it knows about the resources.

```text
azurerm_resource_group.app
        ↓
Azure Resource ID
```

### Real Infrastructure

The actual resource exists in Azure:

```text
Azure
└── Resource Group
    └── rg-app
```

Conceptually:

```text
              Desired
             Configuration
                  │
                  ▼
            ┌─────────────┐
            │  Terraform  │
            └──────┬──────┘
                   │
             ┌─────┴─────┐
             ▼           ▼
          State        Provider
                         │
                         ▼
                    Real Azure
```

---

# 4. State Is a Mapping

This is one of the most important Terraform concepts.

Suppose your configuration contains:

```hcl
resource "azurerm_storage_account" "app" {
  name                     = "mystorage123"
  resource_group_name      = "rg-app"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

Terraform gives the resource a Terraform address:

```text
azurerm_storage_account.app
```

The actual Azure resource has an Azure Resource ID.

Conceptually:

```text
Terraform Address
azurerm_storage_account.app
             │
             ▼
Azure Resource
             │
             ▼
/subscriptions/xxx/resourceGroups/rg-app/providers/...
```

State maintains this relationship.

---

# 5. Terraform Resource Address

A Terraform resource address identifies a resource inside Terraform.

Example:

```text
azurerm_resource_group.app
```

Break it down:

```text
azurerm_resource_group
        │
        └── Resource type

app
│
└── Resource name
```

For a resource using `count`:

```text
azurerm_resource_group.app[0]
```

For a resource using `for_each`:

```text
azurerm_resource_group.app["dev"]
```

State tracks these individual instances.

---

# 6. What Does the State File Contain?

The state file is JSON.

A simplified example:

```json
{
  "version": 4,
  "terraform_version": "1.x",
  "resources": [
    {
      "type": "azurerm_resource_group",
      "name": "app",
      "provider": "...",
      "instances": [
        {
          "attributes": {
            "name": "rg-app",
            "location": "East US",
            "id": "/subscriptions/.../resourceGroups/rg-app"
          }
        }
      ]
    }
  ]
}
```

The actual state structure is more complex.

State can contain information such as:

* Terraform resource addresses
* Resource IDs
* Resource attributes
* Provider information
* Resource instances
* Dependencies
* Metadata
* Values needed by Terraform to manage resources

Depending on the resource and provider, state may also contain sensitive information.

Therefore, **state should be treated as sensitive infrastructure data**.

---

# 7. State vs Terraform Configuration

| Configuration                  | State                               |
| ------------------------------ | ----------------------------------- |
| `.tf` files                    | `terraform.tfstate` or remote state |
| Defines desired infrastructure | Records Terraform's knowledge       |
| Written by developer           | Managed by Terraform                |
| HCL                            | JSON                                |
| Usually stored in Git          | Usually not stored in Git           |
| Describes what should exist    | Maps resources to infrastructure    |

Example:

```text
main.tf
   │
   └── "Create rg-app"

terraform.tfstate
   │
   └── "rg-app exists with this Azure resource ID"
```

---

# 8. State Lifecycle

A simplified Terraform lifecycle is:

```text
terraform init
       │
       ▼
Initialize backend/providers
       │
       ▼
terraform plan
       │
       ├── Read configuration
       ├── Read state
       ├── Query provider
       └── Calculate changes
       │
       ▼
terraform apply
       │
       ▼
Modify infrastructure
       │
       ▼
Update state
```

State is therefore involved throughout Terraform's infrastructure management lifecycle.

---

# 9. What Happens During `terraform plan`?

Suppose configuration says:

```text
VM size = Standard_B2s
```

State records:

```text
VM size = Standard_B2s
```

Azure currently has:

```text
VM size = Standard_B2s
```

Terraform sees that everything is aligned.

```text
Configuration
     │
     ├── Standard_B2s
     │
     ▼
State
     │
     ├── Standard_B2s
     │
     ▼
Azure
     │
     └── Standard_B2s
```

Result:

```text
No changes
```

---

# 10. What Happens When Configuration Changes?

Suppose you modify:

```hcl
size = "Standard_D2s"
```

Terraform compares the desired configuration with its current information.

Conceptually:

```text
Configuration
Standard_D2s

State
Standard_B2s

        ↓

terraform plan

        ↓

Change required
```

Terraform may show:

```text
~ size = "Standard_B2s" -> "Standard_D2s"
```

The `~` means an in-place modification is planned.

---

# 11. Local State

By default, Terraform can store state locally.

Typical project:

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── terraform.tfvars
├── terraform.tfstate
└── terraform.tfstate.backup
```

The state is stored on the machine running Terraform.

Local state is useful for:

* Learning
* Personal labs
* Small experiments
* Single-user environments

But it becomes problematic when multiple people or CI/CD pipelines need to manage the same infrastructure.

---

# 12. Problems With Local State

Imagine:

```text
Developer A
    │
    └── local terraform.tfstate

Developer B
    │
    └── different local terraform.tfstate
```

Both may have different information.

This creates a coordination problem.

For team environments:

```text
Developer A ──┐
Developer B ──┼──► Shared Remote State
Pipeline ─────┘
```

is generally a better model.

---

# 13. Remote State

Remote state means Terraform state is stored outside the local machine in a shared backend.

For Azure, a common solution is Azure Blob Storage.

Conceptually:

```text
Developer
     │
     ▼
Terraform
     │
     ├──────────► Azure Infrastructure
     │
     ▼
Azure Storage Account
     │
     ▼
Blob Container
     │
     ▼
lab.tfstate
```

This allows multiple authorized Terraform users and CI/CD systems to access the same state.

---

# 14. What Is a Terraform Backend?

A Terraform backend determines where Terraform stores state and how state operations are handled.

Example:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "tfstate123"
    container_name       = "tfstate"
    key                  = "lab.tfstate"
  }
}
```

Here:

```text
Backend
   │
   ├── Resource Group
   ├── Storage Account
   ├── Container
   └── State Key
```

The important part is:

```text
key = "lab.tfstate"
```

This identifies the state object used for this Terraform configuration.

---

# 15. Backend vs State

These are not the same thing.

### State

The actual Terraform state data.

```text
lab.tfstate
```

### Backend

The mechanism/location Terraform uses to store and access that state.

```text
azurerm backend
```

Think:

```text
Backend
   │
   └── stores/accesses ──► State
```

---

# 16. Why Remote State Is Important in CI/CD

For your Azure DevOps setup, imagine:

```text
Azure DevOps
      │
      ▼
Self-hosted Agent
      │
      ▼
Terraform
      │
      ├──────────────► Azure
      │
      └──────────────► Azure Blob
                            │
                            ▼
                       lab.tfstate
```

The agent itself should not be treated as the permanent owner of the state.

A self-hosted agent can be replaced, recreated, or another agent can execute the pipeline.

The shared remote backend keeps the state available independently of a particular agent.

---

# 17. State Locking

State locking prevents multiple Terraform operations from modifying the same state simultaneously when the backend supports locking.

Example:

```text
Pipeline A
     │
     ▼
Acquire Lock 🔒
     │
     ▼
terraform apply
     │
     ▼
Update State
     │
     ▼
Release Lock 🔓
```

Meanwhile:

```text
Pipeline B
     │
     ▼
Attempt Terraform operation
     │
     ▼
State already locked
```

This helps prevent concurrent operations against the same state.

---

# 18. Why State Locking Is Needed

Imagine two pipelines:

```text
Pipeline A ──────► terraform apply
Pipeline B ──────► terraform apply
```

Both operate on:

```text
lab.tfstate
```

Without proper coordination, both could attempt to modify the same state simultaneously.

Locking provides a protection mechanism:

```text
lab.tfstate
     │
     └── 🔒 locked by Pipeline A
```

Pipeline B must not independently modify that same state at the same time.

---

# 19. State Lock Error

You may see an error such as:

```text
Error acquiring the state lock
```

The error can include information such as:

```text
Lock Info:
  ID: ...
  Path: ...
  Operation: OperationTypeApply
  Who: ...
```

The important value is the:

```text
LOCK_ID
```

---

# 20. Why Should You NOT Immediately Force-Unlock?

Suppose:

```text
Pipeline A
    │
    └── terraform apply is actually running
             │
             └── State is legitimately locked
```

If you execute:

```bash
terraform force-unlock <LOCK_ID>
```

you could remove the protection while Pipeline A is still operating.

That can lead to concurrent Terraform operations.

Therefore:

```text
Lock error
    ↓
Check whether another Terraform operation is running
    ↓
If running → DO NOT force unlock
    ↓
If operation crashed/stopped and lock is stale
    ↓
Force unlock can be considered
```

---

# 21. How to Force-Unlock State

Terraform provides:

```bash
terraform force-unlock <LOCK_ID>
```

Example:

```bash
terraform force-unlock 12345678-xxxx-xxxx-xxxx-xxxxxxxx
```

Terraform normally asks for confirmation.

This operation removes the Terraform state lock.

It does **not**:

```text
❌ Delete Azure resources
❌ Destroy infrastructure
❌ Modify .tf configuration
❌ Remove a resource from state
```

It removes the lock.

Think:

```text
State
│
├── Resources
│
└── Lock 🔒
       │
       ▼
terraform force-unlock
       │
       ▼
Lock 🔓
```

---

# 22. Safe Force-Unlock Procedure

In a CI/CD environment such as Azure DevOps:

```text
1. Terraform reports state lock error
             ↓
2. Check Azure DevOps running pipelines
             ↓
3. Check whether another Terraform process is active
             ↓
4. Identify the lock ID
             ↓
5. Confirm the operation that created the lock has stopped
             ↓
6. Run terraform force-unlock <LOCK_ID>
             ↓
7. Run Terraform again
```

Never force-unlock simply because a pipeline is waiting.

First establish that the lock is stale.

---

# 23. What Is Terraform Drift?

**Drift is a difference between the infrastructure Terraform expects/manages and the actual infrastructure.**

A common cause is a manual change outside Terraform.

Example:

Terraform configuration:

```text
VM Size = Standard_B2s
```

Terraform state:

```text
VM Size = Standard_B2s
```

Azure:

```text
VM Size = Standard_D2s
```

Now the actual infrastructure differs from what Terraform expects.

That difference is called **drift**.

---

# 24. Simple Drift Example

Initially:

```text
Configuration
     │
     └── Standard_B2s
             │
             ▼
State
     │
     └── Standard_B2s
             │
             ▼
Azure
     │
     └── Standard_B2s
```

Everything matches.

Someone manually changes Azure:

```text
Azure Portal
     │
     ▼
VM size changed
     │
     ▼
Standard_D2s
```

Now:

```text
Configuration
Standard_B2s

State
Standard_B2s

Azure
Standard_D2s
```

This is drift.

---

# 25. Causes of Drift

Drift can happen because of:

### Manual Portal Changes

```text
Azure Portal
     ↓
Resource modified
     ↓
Drift
```

### Azure CLI

```text
az command
     ↓
Resource modified
     ↓
Drift
```

### Other Automation

For example:

```text
Scripts
Automation
ARM/Bicep
External tools
```

may modify infrastructure.

### Another Terraform Configuration

Another Terraform project may manage or modify the same resource.

```text
Terraform Project A
        ↓
Modify Azure Resource
        ↓
Terraform Project B
        ↓
Expected configuration may differ
```

---

# 26. How Terraform Detects Drift

During Terraform planning, Terraform can refresh information from the provider and compare it with the configuration and state.

Conceptually:

```text
terraform plan
       │
       ├── Configuration
       │
       ├── State
       │
       └── Provider/API
               │
               ▼
        Actual Infrastructure
```

Terraform uses these inputs to determine what changes are necessary.

---

# 27. Drift Reconciliation

Suppose:

```text
Configuration:
Standard_B2s

Actual Azure:
Standard_D2s
```

Terraform may plan to bring Azure back toward the configuration:

```text
Standard_D2s
      ↓
Standard_B2s
```

Then:

```bash
terraform apply
```

can apply the planned reconciliation.

The exact action depends on the resource and provider behavior.

---

# 28. Drift Is Different From State Modification

These are frequently confused.

### Drift

Infrastructure changed outside Terraform.

```text
Configuration = B2s
State         = B2s
Azure         = D2s
```

### State modification

Terraform's state tracking is changed.

For example:

```bash
terraform state rm azurerm_resource_group.app
```

This removes the resource from Terraform state.

It does **not** automatically delete the Azure resource.

So:

```text
terraform state rm
        ↓
Remove Terraform tracking
        ≠
Delete Azure resource
```

---

# 29. `terraform state list`

Shows resources currently tracked in state.

```bash
terraform state list
```

Example:

```text
azurerm_resource_group.app
azurerm_storage_account.app
azurerm_virtual_network.main
```

This answers:

> Which resources does this Terraform state currently track?

---

# 30. `terraform state show`

Displays details of one resource in state.

```bash
terraform state show azurerm_resource_group.app
```

Useful for examining what Terraform currently has recorded for that resource.

---

# 31. `terraform show`

Displays the current state in a human-readable form.

```bash
terraform show
```

You can also inspect a plan file:

```bash
terraform show tfplan
```

---

# 32. `terraform state rm`

Example:

```bash
terraform state rm azurerm_resource_group.app
```

This removes the resource from Terraform state.

Important:

```text
Terraform State
     │
     └── Resource removed
```

does not mean:

```text
Azure
     │
     └── Resource deleted
```

The actual Azure resource can remain.

Use this command carefully.

---

# 33. Terraform Import

Suppose an Azure resource already exists:

```text
Azure
└── rg-existing
```

but Terraform doesn't currently track it.

You can associate it with a Terraform resource using import.

For example:

```bash
terraform import azurerm_resource_group.existing /subscriptions/.../resourceGroups/rg-existing
```

Conceptually:

```text
Existing Azure Resource
          │
          ▼
      terraform import
          │
          ▼
Terraform State
          │
          ▼
azurerm_resource_group.existing
```

Import brings an existing resource under Terraform's state management.

After importing, you should ensure your configuration correctly represents the resource.

---

# 34. State and Resource Creation

When you run:

```bash
terraform apply
```

Terraform creates the resource.

Conceptually:

```text
Configuration
      ↓
Terraform
      ↓
Azure API
      ↓
Resource Created
      ↓
Terraform receives resource information
      ↓
State Updated
```

For example:

```text
azurerm_resource_group.app
        ↓
Azure creates rg-app
        ↓
Azure returns resource information
        ↓
State records it
```

---

# 35. State and Resource Destruction

Suppose you remove a resource from your configuration.

Terraform compares:

```text
Configuration
        ↓
Resource no longer declared

State
        ↓
Resource still tracked
```

Terraform may plan:

```text
- destroy resource
```

After successful destruction:

```text
Azure Resource
      ↓
Deleted

Terraform State
      ↓
Resource removed
```

This demonstrates why state is critical to Terraform's lifecycle management.

---

# 36. State Backup

With local state, Terraform may create:

```text
terraform.tfstate.backup
```

Conceptually:

```text
terraform.tfstate
       │
       └── Current state

terraform.tfstate.backup
       │
       └── Previous state information
```

Do not rely solely on this file as your production backup strategy.

For remote state, backend/storage-level backup and versioning capabilities can provide stronger recovery options.

---

# 37. State Versioning

A remote backend can often be combined with storage versioning.

Conceptually:

```text
lab.tfstate
    │
    ├── Version 1
    ├── Version 2
    ├── Version 3
    └── Version 4
```

This can help recover from accidental or unwanted state changes, depending on the backend's capabilities and configuration.

---

# 38. State Security

State should be treated as sensitive.

Why?

Because state can contain:

```text
Resource IDs
Infrastructure information
Configuration information
Potential sensitive values
```

Therefore:

```text
❌ Don't casually commit state to Git
❌ Don't publish state files
❌ Don't expose state publicly
```

Instead:

```text
Terraform
     ↓
Secure Remote Backend
     ↓
Authentication
     +
Authorization
     +
Encryption
     +
Access Control
```

---

# 39. `.gitignore`

For local Terraform projects, commonly ignore:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
```

This helps prevent accidental commits of:

```text
terraform.tfstate
terraform.tfstate.backup
```

Provider/plugin files under `.terraform/` should also normally not be committed.

---

# 40. `.terraform` vs State

These are different.

### `.terraform/`

Terraform working directory data.

It can contain things related to:

```text
Provider plugins
Modules
Backend-related working information
Terraform initialization data
```

### State

```text
terraform.tfstate
```

contains Terraform's persisted state information.

Therefore:

```text
.terraform/
      ≠
terraform.tfstate
```

---

# 41. State and Providers

Terraform uses providers to communicate with infrastructure APIs.

For Azure:

```text
Terraform
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

State works alongside the provider.

Conceptually:

```text
Configuration
      +
State
      +
Provider/API information
      ↓
Terraform Plan
```

---

# 42. State and Dependency Information

Terraform also needs to understand relationships between resources.

Example:

```hcl
resource "azurerm_resource_group" "app" {
  name     = "rg-app"
  location = "East US"
}

resource "azurerm_storage_account" "app" {
  name                = "mystorage123"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
}
```

Terraform understands:

```text
Resource Group
      ↓
Storage Account
```

State contains information Terraform uses as part of managing resource instances and their relationships.

---

# 43. Sensitive Data in State

A common misconception is:

> "If I mark a Terraform variable as sensitive, it will never appear in state."

That is not necessarily true.

For example:

```hcl
variable "password" {
  sensitive = true
}
```

The `sensitive` setting primarily controls how Terraform displays the value.

The value may still be stored in state depending on how the resource/provider handles it.

Therefore:

```text
sensitive = true
```

does not mean:

```text
State contains absolutely no sensitive information
```

Treat the state as sensitive regardless.

---

# 44. State and Secrets

Avoid unnecessarily placing secrets into Terraform configuration or state.

Where possible, use appropriate secret-management mechanisms and provider-supported approaches.

For Azure environments, organizations commonly integrate Terraform with secure identity and secret-management mechanisms rather than storing credentials directly in `.tf` files.

---

# 45. State Locking vs Drift

These are completely different concepts.

| Concept              | Meaning                                                                     |
| -------------------- | --------------------------------------------------------------------------- |
| State Lock           | Prevents conflicting concurrent state operations                            |
| Drift                | Actual infrastructure differs from Terraform's expected configuration/state |
| Force Unlock         | Removes a stale state lock                                                  |
| `terraform state rm` | Removes a resource from Terraform state                                     |
| Import               | Adds an existing resource to Terraform state                                |
| Remote State         | Stores state outside the local machine                                      |
| Backend              | Defines how/where Terraform manages state                                   |

Easy way to remember:

```text
LOCK
 ↓
"Who is currently operating on the state?"

DRIFT
 ↓
"Has the real infrastructure changed outside Terraform?"
```

---

# 46. State File in Azure DevOps CI/CD

For a pipeline such as:

```text
Validate
   ↓
Plan
   ↓
Security & Quality Scan
   ↓
Manual Approval
   ↓
Apply
```

all Terraform stages that operate on the same infrastructure should use the appropriate same backend/state.

Conceptually:

```text
                    Azure DevOps
                         │
                         ▼
                  Self-hosted Agent
                         │
                         ▼
                     Terraform
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
         Azure Provider        Remote Backend
              │                     │
              ▼                     ▼
       Azure Infrastructure     lab.tfstate
```

The important point is that the agent is an execution environment; the remote backend provides persistent shared state.

---

# 47. Multiple Agents

Suppose your Azure DevOps agent pool contains:

```text
Agent-01
Agent-02
Agent-03
```

and all agents have Terraform installed.

Terraform state should still be shared through the configured backend:

```text
Agent-01 ──┐
Agent-02 ──┼──► Remote State
Agent-03 ──┘
```

The state should not depend on which particular self-hosted agent happens to execute the job.

State locking becomes especially important when multiple pipeline executions could target the same state.

---

# 48. State in Your `lab.tfstate` Setup

For your Terraform environment, you have been using:

```text
lab.tfstate
```

as the state key.

Conceptually:

```text
Azure Storage Account
       │
       ▼
Container
       │
       ▼
lab.tfstate
```

Your pipeline:

```text
Azure DevOps
       │
       ▼
Terraform
       │
       ▼
Remote Backend
       │
       ▼
lab.tfstate
```

This means the Terraform state is persistent independently of the particular Azure DevOps agent running the job.

---

# 49. State Commands — Quick Reference

### Show state

```bash
terraform show
```

### List resources

```bash
terraform state list
```

### Show one resource

```bash
terraform state show <resource-address>
```

Example:

```bash
terraform state show azurerm_resource_group.app
```

### Remove resource from state

```bash
terraform state rm <resource-address>
```

### Import existing resource

```bash
terraform import <resource-address> <resource-id>
```

### Force-unlock stale state

```bash
terraform force-unlock <LOCK_ID>
```

---

# 50. Important Difference Between Commands

```text
terraform state rm
        ↓
Remove resource from state
        ↓
Azure resource normally remains

terraform import
        ↓
Add existing resource to state

terraform force-unlock
        ↓
Remove state lock

terraform destroy
        ↓
Destroy infrastructure
```

Do not confuse these commands.

---

# 51. Common State Mistakes

## Mistake 1 — Commit `terraform.tfstate` to Git

Avoid this for normal team workflows.

```text
Git
 └── terraform.tfstate  ❌
```

Use an appropriate remote backend instead.

---

## Mistake 2 — Delete the state file manually

Deleting state does not delete the Azure infrastructure.

Instead, you can end up with:

```text
Azure
 └── Resources still exist

Terraform
 └── No state information
```

Terraform may then no longer know how those resources correspond to its configuration.

---

## Mistake 3 — Force-unlock without checking

```bash
terraform force-unlock <LOCK_ID>
```

should not be used blindly.

First verify that the lock is stale.

---

## Mistake 4 — Manually edit state

The state file is JSON, but that does not mean you should routinely edit it manually.

Prefer Terraform state commands and supported workflows.

---

## Mistake 5 — Multiple Terraform projects manage the same resources

This can create conflicts and confusing state relationships.

A resource should have a clear ownership model.

---

# 52. State Ownership

A good Terraform design establishes:

```text
Which Terraform project
        ↓
owns which infrastructure
        ↓
and which state
```

Example:

```text
Project A
   │
   └── lab.tfstate
        │
        └── Lab infrastructure

Project B
   │
   └── prod.tfstate
        │
        └── Production infrastructure
```

Avoid accidentally having multiple independent states manage the same resource.

---

# 53. State File Mental Model

Remember this simple model:

```text
                 Terraform
                     │
       ┌─────────────┼─────────────┐
       │             │             │
       ▼             ▼             ▼
 Configuration     State        Provider
       │             │             │
       │             │             ▼
       │             │          Azure API
       │             │             │
       └─────────────┴─────────────┘
                     │
                     ▼
              Terraform Plan
                     │
                     ▼
              Terraform Apply
                     │
                     ▼
             Actual Infrastructure
```

---

# 54. Complete State Lifecycle

```text
                 terraform init
                       │
                       ▼
                  Backend ready
                       │
                       ▼
                terraform plan
                       │
           ┌───────────┼───────────┐
           │           │           │
           ▼           ▼           ▼
      Configuration   State     Azure API
           │           │           │
           └───────────┼───────────┘
                       │
                       ▼
                 Change Plan
                       │
                       ▼
                terraform apply
                       │
                       ▼
               Azure Infrastructure
                       │
                       ▼
                  State Updated
```

If an operation needs state locking:

```text
terraform apply
      │
      ▼
Acquire Lock 🔒
      │
      ▼
Perform operation
      │
      ▼
Update state
      │
      ▼
Release Lock 🔓
```

If the infrastructure was changed externally:

```text
External Change
      │
      ▼
Actual Infrastructure
      │
      X
      │
Terraform expectation
      │
      ▼
     Drift
      │
      ▼
terraform plan
      │
      ▼
Possible reconciliation
```

---

# 55. Interview Questions

## Q1. What is Terraform state?

Terraform state is the persistent record Terraform uses to map Terraform resources to real infrastructure and manage changes.

---

## Q2. Why is state required?

It allows Terraform to maintain resource mappings and determine what changes are required between the desired configuration and infrastructure.

---

## Q3. What is remote state?

State stored in a shared remote backend rather than only on the local Terraform machine.

---

## Q4. What is a backend?

A backend defines how and where Terraform stores and accesses state.

---

## Q5. What is state locking?

State locking prevents conflicting concurrent Terraform operations against the same state when supported by the backend.

---

## Q6. How do you force-unlock Terraform state?

```bash
terraform force-unlock <LOCK_ID>
```

Only after verifying that the lock is stale and no Terraform operation is still running.

---

## Q7. What is drift?

Drift occurs when the actual infrastructure differs from what Terraform expects, often because infrastructure was changed outside Terraform.

---

## Q8. How can you identify resources tracked by state?

```bash
terraform state list
```

---

## Q9. Does `terraform state rm` delete the resource?

No.

It removes the resource from Terraform's state tracking.

---

## Q10. How do you bring an existing resource under Terraform management?

Use Terraform import:

```bash
terraform import <resource-address> <resource-id>
```

---

## Q11. Should `terraform.tfstate` be committed to Git?

Normally, no. Use an appropriate remote backend for shared/team infrastructure.

---

## Q12. Why is state sensitive?

Because state may contain infrastructure details and, depending on the resources/provider, potentially sensitive values.

---

# 56. Final Mental Model

If you remember only one diagram, remember this:

```text
                 TERRAFORM
                     │
          ┌──────────┼──────────┐
          │          │          │
          ▼          ▼          ▼
      .tf files    State      Provider
     "I want"    "I know"    "Ask Azure"
          │          │          │
          └──────────┼──────────┘
                     ▼
              terraform plan
                     │
                     ▼
              Required Changes
                     │
                     ▼
              terraform apply
                     │
                     ▼
             Azure Infrastructure
```

And for a team/CI-CD environment:

```text
Developer ──────┐
                │
Azure DevOps ───┼──► Terraform ───► Azure
                │       │
Another Agent ──┘       │
                        ▼
                 Remote Backend
                        │
                        ▼
                   lab.tfstate
                        │
                        ▼
                  State Lock 🔒
```

### The four concepts you should never confuse

```text
STATE
"What does Terraform know?"

BACKEND
"Where/how is the state stored?"

LOCK
"Who is currently operating on this state?"

DRIFT
"Does actual infrastructure differ from what Terraform expects?"
```

These four concepts form the foundation for understanding **Terraform State Management**.
