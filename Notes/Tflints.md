TFLint

If you're learning **Terraform for DevOps interviews**, **TFLint** is one of the first tools you should know. It is often used together with `terraform fmt`, `terraform validate`, `tfsec`/`Trivy`, and `Gitleaks`.

---

# What is TFLint?

**TFLint (Terraform Linter)** is an open-source static analysis tool that analyzes Terraform code for:

* Syntax and best-practice violations
* Deprecated resources and arguments
* Cloud provider-specific issues (AWS, Azure, GCP)
* Unused declarations
* Naming convention violations
* Custom organizational policies

> **Simple definition:**
> TFLint checks the **quality and correctness** of Terraform code before it is deployed.

---

# Why do we need TFLint?

Terraform can successfully validate code, but that doesn't mean the code follows best practices.

For example:

Terraform accepts:

```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet1"
  location            = "centralindia"
  resource_group_name = "rg1"
  address_space       = ["10.0.0.0/16"]
}
```

`terraform validate`

✔ No syntax errors

But TFLint can identify issues such as:

* Deprecated arguments
* Invalid Azure region names
* Wrong VM sizes (provider-dependent)
* Unused variables
* Missing required tags (if configured)
* Provider best-practice violations

---

# Terraform Validation vs TFLint

| Tool                 | Purpose                                                      |
| -------------------- | ------------------------------------------------------------ |
| `terraform fmt`      | Formats Terraform code                                       |
| `terraform validate` | Checks syntax and configuration validity                     |
| **TFLint**           | Checks best practices, quality, and provider-specific issues |
| `tfsec` / `Trivy`    | Finds security misconfigurations                             |
| `Gitleaks`           | Detects hardcoded secrets                                    |

---

# How TFLint Works

```text
Terraform Code
       │
       ▼
terraform fmt
       │
       ▼
terraform validate
       │
       ▼
TFLint
       │
       ▼
Best Practice Checks
       │
       ▼
Warnings / Errors
```

---

# Install TFLint on Windows

### Using Winget

```powershell
winget install terraform-linters.tflint
```

Verify:

```powershell
tflint --version
```

Example:

```
TFLint version 0.59.x
```

---

# Installing TFLint on Windows (Manual Method)
## Step 1: Download TFLint
Go to the official TFLint GitHub Releases page.
Download the Windows ZIP file for your system (for example, tflint_windows_amd64.zip).
Extract the ZIP file.
## Step 2: Place the executable

Move the extracted executable to a folder, for example:
```
C:\Tools\tflint.exe
```
You can choose any folder, but C:\Tools is a common location for command-line tools.

## Step 3: Add the folder to the PATH
Search Environment Variables in Windows.
Open Edit the system environment variables.
```
Click Environment Variables.
Under System Variables, select Path → Edit.
Click New.
Add:
C:\Tools
Click OK to save.
```
# Scan a Terraform Project

Navigate to your Terraform directory:

```bash
cd D:\terraform_repo
```

Run:

```bash
tflint
```

If everything is good:

```
No issues found!
```

---

# Azure Plugin

For Azure Terraform projects, install the Azure ruleset.

Create `.tflint.hcl`

```hcl
plugin "azurerm" {
  enabled = true
  version = "0.28.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
```

Download the plugin:

```bash
tflint --init
```

Now run:

```bash
tflint
```

---

# Example 1 – Unused Variable

```hcl
variable "vm_name" {
  type = string
}
```

If `vm_name` is never used:

```
Warning: variable "vm_name" is declared but never used
```

---

# Example 2 – Deprecated Attribute

Suppose Azure deprecates an argument.

Terraform may still allow it.

TFLint warns:

```
Deprecated argument found
```

---

# Example 3 – Invalid Region

```hcl
location = "centralindiaa"
```

Terraform might not catch this until deployment.

With the Azure ruleset, TFLint can identify invalid region values before deployment.

---

# Common Commands

### Initialize plugins

```bash
tflint --init
```

### Scan current directory

```bash
tflint
```

### Scan recursively

```bash
tflint --recursive
```

### Show only errors

```bash
tflint --minimum-failure-severity=error
```

### Output JSON

```bash
tflint --format=json
```
```
for cicd pipeline commapct report
tflint --recursive --format json > tflint-report.json
```
```
for human readble pretty printed report
tflint --recursive --format json | jq . > tflint-report.json
---

# Configuration File

`.tflint.hcl`

Example:

```hcl
plugin "azurerm" {
  enabled = true
  version = "0.28.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

config {
  module = true
}
```

---

# CI/CD Pipeline

Typical pipeline:

```text
Git Push
    │
    ▼
terraform fmt
    │
    ▼
terraform validate
    │
    ▼
TFLint
    │
    ▼
Gitleaks
    │
    ▼
tfsec / Trivy
    │
    ▼
terraform plan
    │
    ▼
terraform apply
```

If TFLint finds an issue, the pipeline can fail before infrastructure is created.

---

# TFLint vs Terraform Validate

Terraform code:

```hcl
resource "azurerm_linux_virtual_machine" "vm" {
  name = "vm1"
}
```

### `terraform validate`

✔ Checks:

* Syntax
* Resource structure
* Variable references

### TFLint

✔ Checks:

* Best practices
* Azure-specific rules
* Deprecated usage
* Unused code
* Provider recommendations

---

# Advantages

* Fast static analysis
* Provider-specific rules (Azure, AWS, GCP)
* Easy CI/CD integration
* Custom rules support
* Improves Terraform code quality
* Detects issues before deployment

---

# Limitations

* Doesn't create or modify infrastructure.
* Doesn't detect leaked secrets (use Gitleaks).
* Doesn't identify security misconfigurations (use tfsec or Trivy).
* Some provider-specific checks require installing the appropriate ruleset.

---

# DevOps Interview Questions

### 1. What is TFLint?

**Answer:** TFLint is a Terraform linter that performs static analysis on Terraform code to detect best-practice violations, provider-specific issues, deprecated arguments, and unused declarations before deployment.

---

### 2. What is the difference between `terraform validate` and `tflint`?

| `terraform validate`               | `tflint`                               |
| ---------------------------------- | -------------------------------------- |
| Validates syntax and configuration | Checks code quality and best practices |
| Built into Terraform               | Separate tool                          |
| Basic validation                   | Advanced provider-specific linting     |

---

### 3. Can TFLint fail a CI/CD pipeline?

Yes. Organizations commonly run TFLint in Azure DevOps, GitHub Actions, Jenkins, or GitLab CI/CD. If critical linting issues are found, the pipeline fails so they can be fixed before deployment.

---

### 4. Why do we use `tflint --init`?

`tflint --init` downloads and installs the plugins defined in `.tflint.hcl`, such as the Azure (`azurerm`) ruleset, so provider-specific checks can be performed.

---

## Hands-on practice for your Terraform project

Since you're already building an Azure Terraform lab with Resource Groups, VNets, Subnets, Public IPs, NICs, and Linux VMs, the next exercises are:

1. Install TFLint on Windows.
2. Create a `.tflint.hcl` file with the Azure ruleset.
3. Run `tflint --init`.
4. Run `tflint` on your project.
5. Intentionally introduce issues (for example, an invalid Azure region or an unused variable) and observe how TFLint reports them.

This will give you practical experience that's directly relevant to real-world DevOps workflows and interviews.
