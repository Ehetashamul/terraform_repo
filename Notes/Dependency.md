# Azure Terraform Dependencies (Concept Inside)

Terraform dependencies determine **the order in which Azure resources are created, updated, or destroyed**. Terraform builds a **Dependency Graph (DAG - Directed Acyclic Graph)** to understand which resources depend on others.

Think of it like constructing a building:

* Foundation → Walls → Roof
* You cannot build the roof before the walls.

Similarly in Azure:

```
Resource Group
      │
      ▼
Virtual Network
      │
      ▼
Subnet
      │
      ▼
Network Interface
      │
      ▼
Virtual Machine
```

Terraform automatically understands this dependency if one resource references another.

---

# Types of Dependencies

Terraform supports two types of dependencies:

```
Terraform Dependencies
│
├── Implicit Dependency
│      (Automatic)
│
└── Explicit Dependency
       (Manual using depends_on)
```

---

# 1. Implicit Dependency (Recommended)

Terraform automatically creates dependencies whenever one resource references another.

## Example

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "demo-rg"
  location = "Central India"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "demo-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.0.0.0/16"]
}
```

Terraform sees:

```
azurerm_virtual_network
            │
            ▼
azurerm_resource_group
```

because of:

```hcl
resource_group_name = azurerm_resource_group.rg.name
```

No `depends_on` is needed.

### Execution Order

```
Create Resource Group
        ↓
Create Virtual Network
```

---

# Azure Example (VM Deployment)

```
Resource Group
      │
      ▼
Virtual Network
      │
      ▼
Subnet
      │
      ▼
Network Interface
      │
      ▼
Virtual Machine
```

Terraform automatically detects these relationships because each resource references the previous one.

Example:

```hcl
resource "azurerm_network_interface" "nic" {
  subnet_id = azurerm_subnet.subnet.id
}
```

Terraform understands:

```
NIC depends on Subnet
```

---

# 2. Explicit Dependency

Sometimes resources do **not** reference each other directly, but one must still wait for the other.

In that case, use:

```hcl
depends_on
```

---

## Syntax

```hcl
depends_on = [
    resource.resource_name
]
```

---

## Azure Example

Suppose you create:

* Storage Account
* Role Assignment

The role assignment doesn't reference the storage account directly, but it should only be created after the storage account exists.

```hcl
resource "azurerm_storage_account" "storage" {

}

resource "azurerm_role_assignment" "role" {

  depends_on = [
    azurerm_storage_account.storage
  ]
}
```

Execution:

```
Storage Account
        ↓
Role Assignment
```

---

# Another Azure Example

Suppose you run an Azure VM extension after the VM is ready.

```
Virtual Machine
        │
        ▼
VM Extension
```

```hcl
resource "azurerm_windows_virtual_machine" "vm" {

}

resource "azurerm_virtual_machine_extension" "extension" {

  depends_on = [
      azurerm_windows_virtual_machine.vm
  ]
}
```

Terraform waits until the VM is fully created.

---

# Real Azure Scenario

Deploying a Linux VM typically follows this dependency chain:

```
Resource Group
      │
      ▼
Virtual Network
      │
      ▼
Subnet
      │
      ▼
Public IP
      │
      ▼
Network Interface
      │
      ▼
Virtual Machine
```

Example references:

```hcl
resource_group_name = azurerm_resource_group.rg.name

virtual_network_name = azurerm_virtual_network.vnet.name

subnet_id = azurerm_subnet.subnet.id

public_ip_address_id = azurerm_public_ip.pip.id

network_interface_ids = [
    azurerm_network_interface.nic.id
]
```

Terraform automatically creates the dependency graph.

---

# Visualizing the Dependency Graph

Terraform internally builds a graph like this:

```
            Resource Group
                  │
                  ▼
        Virtual Network
                  │
                  ▼
              Subnet
             /      \
            ▼        ▼
      Public IP    NSG
            │        │
            └──┬─────┘
               ▼
      Network Interface
               │
               ▼
         Virtual Machine
               │
               ▼
         VM Extension
```

Terraform executes independent resources in parallel whenever possible.

---

# Dependency During Destroy

Dependencies also control deletion order.

Creation:

```
RG
 ↓
VNet
 ↓
Subnet
 ↓
VM
```

Destruction:

```
VM
 ↑
Subnet
 ↑
VNet
 ↑
RG
```

Terraform destroys child resources before parents to avoid Azure API errors.

---

# When to Use `depends_on`

Use `depends_on` only when Terraform cannot infer the dependency.

Good use cases:

* VM Extension after VM creation
* RBAC Role Assignment after resource creation
* Key Vault access policy after Key Vault creation
* Provisioners that rely on another resource
* Azure resources with hidden API dependencies

Avoid using `depends_on` when references already exist, as it can make plans slower and harder to maintain.

---

# Best Practices

* ✅ Prefer implicit dependencies by referencing resource attributes.
* ✅ Use `depends_on` only when necessary.
* ✅ Reference resource IDs instead of hardcoded values.
* ✅ Let Terraform build the dependency graph automatically.
* ✅ Review execution order with `terraform graph` if troubleshooting complex deployments.

---

# Interview Questions

### Q1. What is a Terraform dependency?

A dependency defines the order in which Terraform creates, updates, or destroys resources. Terraform determines this using its dependency graph (DAG).

---

### Q2. What is the difference between implicit and explicit dependencies?

| Implicit Dependency                            | Explicit Dependency                                   |
| ---------------------------------------------- | ----------------------------------------------------- |
| Created automatically from resource references | Defined manually using `depends_on`                   |
| Preferred approach                             | Use only when Terraform cannot infer the relationship |
| Simpler and easier to maintain                 | Adds manual dependency management                     |

---

### Q3. Does Terraform create resources one by one?

No. Terraform creates resources **in parallel** whenever there are no dependencies. Dependent resources wait until their prerequisites are complete.

---

### Q4. Why is `depends_on` not recommended everywhere?

Because it introduces unnecessary constraints, reducing parallelism and making configurations harder to maintain. Use it only for dependencies that Terraform cannot detect automatically.

---

### Q5. Can dependencies affect resource deletion?

Yes. Terraform destroys resources in the reverse dependency order, ensuring child resources are removed before their parent resources.

---

# Key Takeaways

* **Implicit dependencies** are automatic and should be your first choice.
* **Explicit dependencies** (`depends_on`) are for hidden or non-reference relationships.
* Terraform builds a **Directed Acyclic Graph (DAG)** to determine execution order.
* Resources without dependencies are created in parallel for faster deployments.
* In Azure, common dependency chains include **Resource Group → VNet → Subnet → NIC → VM**, which Terraform typically infers automatically through resource references.
