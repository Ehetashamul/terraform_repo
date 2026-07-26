# tfsec (Terraform Security Scanner)

`tfsec` is an **open-source static application security testing (SAST) tool for Terraform Infrastructure as Code (IaC)**. It scans Terraform (`.tf`) files **before deployment** to detect security misconfigurations, helping teams follow the **Shift Left Security** approach. It performs static analysis without deploying infrastructure or requiring cloud credentials. Today, Aqua Security recommends using **Trivy**, as tfsec's scanning engine has been merged into it. ([GitHub][1])

---

# Why tfsec is Needed

Terraform validates **syntax**, but it **does not validate security**.

For example:

* `terraform validate` ✅ Checks if the code is syntactically correct.
* `terraform plan` ✅ Shows infrastructure changes.
* `tfsec` ✅ Detects security risks before deployment.

Without tfsec, Terraform may successfully deploy infrastructure that is insecure.

---

# Common Security Issues Detected

tfsec can identify:

* Publicly accessible storage accounts
* Unencrypted storage
* Unencrypted databases
* Open Security Groups (0.0.0.0/0)
* Missing logging
* Weak network security rules
* Missing resource tags
* Disabled encryption at rest
* Public IPs on sensitive resources
* Compliance violations (CIS, best practices)

---

# Supported Cloud Providers

tfsec supports security checks for:

* AWS
* Azure
* Google Cloud (GCP)
* Kubernetes
* Oracle Cloud
* DigitalOcean
* OpenStack
* GitHub resources

and several other Terraform providers. ([GitHub][1])

---

# How tfsec Works

```
Terraform Code
       │
       ▼
   tfsec Scanner
       │
       ▼
Analyzes Terraform Resources
       │
       ▼
Checks Against Hundreds of Security Rules
       │
       ▼
Security Report
```

Unlike Terraform, tfsec never creates infrastructure.

---

# Installation

## Windows (Chocolatey)

```powershell
choco install tfsec
```

## Scoop

```powershell
scoop install tfsec
```

## macOS

```bash
brew install tfsec
```

---

# Basic Command

Scan the current Terraform project:

```bash
tfsec .
```

Example:

```
Result #1 HIGH

Resource:
azurerm_storage_account.storage

Problem:
Storage Account should have HTTPS only enabled

Impact:
Traffic could be intercepted

Resolution:
Enable HTTPS only.
```

---

# Scan a Specific Folder

```bash
tfsec ./terraform
```

---

# Show Only High/Critical Issues

```bash
tfsec . --minimum-severity HIGH
```

---

# Export Results

JSON:

```bash
tfsec . --format json --out results.json

tfsec . --tfvars-file terraform.tfvars  --format json --out tfsec-report.json
```

SARIF (GitHub Security):

```bash
tfsec . --format sarif --out results.sarif
```

---

# Ignore a Specific Rule

Inline:

```terraform
#tfsec:ignore:azure-storage-enable-https-traffic-only

resource "azurerm_storage_account" "example" {
...
}
```

Or exclude checks from the command line:

```bash
tfsec . -e azure-storage-enable-https-traffic-only
```

---

# Example

## Insecure Terraform

```terraform
resource "azurerm_storage_account" "example" {
  account_tier = "Standard"

  enable_https_traffic_only = false
}
```

tfsec reports:

```
HIGH

HTTPS traffic is disabled.
```

---

## Secure Version

```terraform
resource "azurerm_storage_account" "example" {
  account_tier = "Standard"

  enable_https_traffic_only = true
}
```

No security issue is reported.

---

# CI/CD Integration

A common DevSecOps pipeline looks like this:

```
Git Push
    │
    ▼
Terraform fmt
    │
    ▼
Terraform validate
    │
    ▼
TFLint
    │
    ▼
tfsec
    │
    ▼
Terraform plan
    │
    ▼
Terraform apply
```

This catches formatting, syntax, quality, and security issues before deployment.

---

# tfsec vs TFLint vs Checkov

| Feature           | Terraform Validate | TFLint | tfsec          | Checkov                                          |
| ----------------- | ------------------ | ------ | -------------- | ------------------------------------------------ |
| Syntax Validation | ✅                  | ❌      | ❌              | ❌                                                |
| Best Practices    | ❌                  | ✅      | Limited        | ✅                                                |
| Security Scanning | ❌                  | ❌      | ✅              | ✅                                                |
| Compliance Checks | ❌                  | ❌      | ✅              | ✅                                                |
| Multi-IaC Support | ❌                  | ❌      | Terraform only | Terraform, Kubernetes, CloudFormation, ARM, etc. |

---

# tfsec vs Trivy

| tfsec                      | Trivy                                                             |
| -------------------------- | ----------------------------------------------------------------- |
| Terraform-focused scanner  | Comprehensive security scanner                                    |
| Scans Terraform IaC        | Scans Terraform, containers, Kubernetes, secrets, SBOMs, and more |
| Standalone tool            | Successor recommended by Aqua Security                            |
| Limited future development | Actively maintained                                               |

Aqua Security has integrated tfsec into Trivy and recommends using `trivy config` for new projects because it provides the same Terraform security checks along with broader security capabilities. ([GitHub][1])

---

# DevOps Interview Questions

### Q1. What is tfsec?

**Answer:** tfsec is a static security scanner that analyzes Terraform code to detect security misconfigurations before infrastructure is deployed.

### Q2. Does tfsec require cloud credentials?

**Answer:** No. It analyzes Terraform files locally using static analysis.

### Q3. What type of testing does tfsec perform?

**Answer:** Static Application Security Testing (SAST) for Infrastructure as Code.

### Q4. What is the difference between TFLint and tfsec?

**Answer:** TFLint focuses on Terraform code quality and best practices, while tfsec focuses on identifying security misconfigurations.

### Q5. Is tfsec still recommended?

**Answer:** Existing tfsec pipelines continue to work, but for new projects Aqua Security recommends **Trivy**, which includes tfsec's Terraform scanning engine and receives ongoing development. ([GitHub][1])

[1]: https://github.com/aquasecurity/tfsec?utm_source=chatgpt.com "GitHub - aquasecurity/tfsec: Tfsec is now part of Trivy · GitHub"
