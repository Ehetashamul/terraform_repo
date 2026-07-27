# 📌 What is Infracost?

**Infracost** is an open-source **FinOps** tool that estimates the **monthly cost of your cloud infrastructure before it is deployed**.

Instead of discovering cloud costs after deployment (when the bill arrives), Infracost analyzes your **Infrastructure as Code (IaC)** and tells you how much your resources will cost. It supports Terraform and other IaC frameworks across AWS, Azure, and Google Cloud. ([Infracost][1])

---

# Why do we need Infracost?

Imagine you write this Terraform code:

```hcl
resource "azurerm_linux_virtual_machine" "vm" {
  size = "Standard_D4s_v5"
}
```

Without Infracost:

```
Write Terraform
      ↓
terraform apply
      ↓
Azure creates VM
      ↓
End of month → Huge bill 😢
```

With Infracost:

```
Write Terraform
      ↓
Run Infracost
      ↓
Estimated Monthly Cost
      ↓
Decide if acceptable
      ↓
terraform apply
```

This helps prevent costly mistakes before deployment. ([Infracost][2])

---

# Real-world Example

Suppose a developer changes:

```hcl
size = "Standard_B2s"
```

to

```hcl
size = "Standard_D16s_v5"
```

Terraform will simply create the VM.

Infracost will report something like:

```
Current cost:
$42/month

New cost:
$620/month

Difference:
+$578/month
```

Now the reviewer immediately knows the financial impact before approving the change.

---

# Where is Infracost used?

It can be integrated into:

* Local developer machines
* VS Code
* GitHub Actions
* Azure DevOps Pipelines
* GitLab CI
* Jenkins
* Pull Requests
* Terraform workflows
* FinOps processes

It can also show cost changes directly in pull requests. ([Infracost][1])

---

# Supported Cloud Providers

* ✅ Microsoft Azure
* ✅ AWS
* ✅ Google Cloud Platform (GCP)

---

# Supported IaC Tools

* Terraform
* Terragrunt
* CloudFormation
* AWS CDK

Support continues to expand. ([Go Packages][3])

---

# How Infracost Works

```
Terraform Code
       │
       ▼
Infracost CLI
       │
Reads resource types
Reads instance sizes
Reads disk sizes
Reads regions
       │
       ▼
Cloud Pricing API
       │
Gets latest prices
       ▼
Monthly Cost Estimate
```

Important: Infracost **does not require cloud credentials** for basic cost estimation and **does not send your Terraform state or secrets** to calculate prices. It extracts only pricing-related parameters. ([Infracost][2])

---

# Installation (Windows)

```powershell
choco install infracost
```

or download the executable manually and add it to your system `PATH`.

Verify:

```bash
infracost --version
```

---

# Setup

Authenticate using the interactive setup:

```bash
infracost setup
```

or set your API key:

```bash
export INFRACOST_API_KEY=ics_v1_xxx
```

You recently configured the API key using the environment variable, which is one supported approach. ([Infracost][1])

---

# Basic Commands

### Check version

```bash
infracost --version
```

### Scan Terraform project

```bash
infracost scan
```

### Cost breakdown

```bash
infracost breakdown --path .
```

### Compare cost changes

```bash
infracost diff
```

---

# Sample Output

```
Project: Azure Infrastructure

VM
  Standard_B2s
  $38/month

Managed Disk
  128 GB
  $6/month

Storage Account
  $2/month

--------------------------
Total Estimated Cost
$46/month
```

---

# In CI/CD Pipeline

```
Developer
     │
     ▼
Git Push
     │
     ▼
Azure DevOps Pipeline
     │
     ▼
Terraform Validate
     │
     ▼
TFLint
     │
     ▼
tfsec
     │
     ▼
Checkov
     │
     ▼
TruffleHog
     │
     ▼
Infracost
     │
     ▼
Shows Cost Difference
     │
     ▼
Approve PR
     │
     ▼
terraform apply
```

---

# Advantages

* Prevents unexpected cloud bills
* Shows cost impact before deployment
* Integrates with CI/CD
* Supports pull request cost reviews
* Encourages cost-aware infrastructure design
* Supports FinOps practices
* No cloud credentials required for basic estimates

---

# Limitations

* Estimates are based on pricing data and configuration, so actual bills can vary with real usage.
* Not every cloud resource is supported.
* Usage-based services may require additional usage information for accurate estimates. ([Infracost][4])

---

# DevOps Interview Questions

### 1. What is Infracost?

A tool that estimates cloud infrastructure costs from Infrastructure as Code before deployment.

### 2. Why use Infracost?

To detect and review infrastructure cost changes early in the development lifecycle.

### 3. Does Infracost deploy resources?

No. It only analyzes infrastructure code and estimates costs.

### 4. Does it require cloud credentials?

Not for standard cost estimation from Terraform code. ([Infracost][2])

### 5. Which IaC tools are supported?

Terraform, Terragrunt, CloudFormation, and AWS CDK.

### 6. Which cloud providers are supported?

AWS, Azure, and Google Cloud.

### 7. Can Infracost work in Azure DevOps?

Yes. It integrates with Azure DevOps, GitHub, GitLab, and other CI/CD systems. ([Infracost][1])

---

## Easy Way to Remember

> **Terraform** creates infrastructure.
> **TFLint** checks code quality.
> **tfsec/Checkov** check security.
> **TruffleHog** detects secrets.
> **Infracost** estimates the cost before deployment.

[1]: https://www.infracost.io/docs/?utm_source=chatgpt.com "Get started | Infracost"
[2]: https://www.infracost.io/docs/faq/?utm_source=chatgpt.com "FAQ | Infracost"
[3]: https://pkg.go.dev/github.com/infracost/infracost?utm_source=chatgpt.com "infracost package - github.com/infracost/infracost - Go Packages"
[4]: https://www.infracost.io/docs/supported_resources/overview/?utm_source=chatgpt.com "Overview | Infracost"


# Steps for setup

Your steps are correct. Here's a cleaner and more professional version you can add to your DevOps notes or GitHub README.

# Infracost Setup and Usage (Terraform)

## Step 1: Create an Infracost Account

Sign up or log in to the Infracost dashboard and generate your API key.

* Visit: [https://dashboard.infracost.io](https://dashboard.infracost.io)
* Copy your API key (e.g., `ics_v1_xxxxxxxxx`)

---

## Step 2: Export the API Key

Set the API key as an environment variable.

### Git Bash

```bash
export INFRACOST_API_KEY="ics_v1_xxxxxxxxx"
```

### PowerShell

```powershell
$env:INFRACOST_API_KEY="ics_v1_xxxxxxxxx"
```

### Verify

**Git Bash**

```bash
echo $INFRACOST_API_KEY
```

**PowerShell**

```powershell
echo $env:INFRACOST_API_KEY
```

If the API key is displayed, the configuration is successful.

---

## Step 3: Initialize the Terraform Project

Terraform must be initialized before running Infracost.

```bash
terraform init
```

This command:

* Downloads required providers
* Downloads Terraform modules
* Creates the `.terraform` directory
* Initializes the backend (if configured)

---

## Step 4: Generate a Terraform Plan

Create a binary plan file.

```bash
terraform plan -out=tfplan.binary
```

This plan contains:

* Resources to be created
* Resources to be updated
* Resources to be destroyed

Infracost reads this file to calculate accurate infrastructure costs.

---

## Step 5: Run Infracost

### Option 1: Analyze the Terraform Plan (Recommended)

```bash
infracost breakdown --path=tfplan.binary --format=table
```

### Option 2: Analyze Terraform Code Directly

```bash
infracost breakdown --path=. --format=table
```

This scans the Terraform configuration without using a plan file.

---

## Sample Output

```text
Project: Terraform Demo

 Name                Monthly Qty      Unit Price    Monthly Cost
 aws_instance        730 hours        $0.0116/hr        $8.47
 aws_s3_bucket       10 GB            $0.023/GB         $0.23
 aws_eip             1                $3.60             $3.60

---------------------------------------------------------------
Estimated Monthly Cost                              $12.30
```

---

# Common Infracost Commands

Check the installed version:

```bash
infracost --version
```

Show help:

```bash
infracost --help
```

Generate a JSON report:

```bash
infracost breakdown --path=tfplan.binary --format=json
```

Generate an HTML report:

```bash
infracost breakdown --path=tfplan.binary --format=html --out-file=report.html
```

Save the table output to a file:

```bash
infracost breakdown --path=tfplan.binary --format=table --out-file=cost.txt
```

Compare costs between the current and planned infrastructure:

```bash
infracost diff --path=tfplan.binary
```

---

# Typical Workflow

```text
Terraform Code
      │
      ▼
terraform init
      │
      ▼
terraform plan -out=tfplan.binary
      │
      ▼
Export INFRACOST_API_KEY
      │
      ▼
infracost breakdown --path=tfplan.binary
      │
      ▼
Monthly Cost Report
```

### Best Practice

For the most accurate pricing, use the Terraform plan (`tfplan.binary`) rather than scanning the code directly. The plan contains resolved values for variables, modules, and resource attributes, allowing Infracost to produce more precise cost estimates.
