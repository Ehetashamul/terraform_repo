## What is Gitleaks?

**Gitleaks** is an **open-source secret scanning tool** used in **DevSecOps** to detect **hardcoded secrets** such as passwords, API keys, access tokens, private keys, and cloud credentials before they are exposed in source code or Git history. It can scan Git repositories, directories, individual files, or input streams (`stdin`). ([GitHub][1])

---

# Why do we need Gitleaks?

Developers sometimes accidentally commit secrets like:

* Azure Client Secret
* AWS Access Key
* GitHub Personal Access Token
* SSH Private Key
* Database Password
* API Tokens
* JWT Tokens

If these are pushed to GitHub, Azure DevOps, or GitLab, attackers can misuse them.

Gitleaks helps prevent these accidental leaks.

---

# How Gitleaks Works

```text
Developer writes code
        │
        ▼
Gitleaks scans repository
        │
        ▼
Regex + Entropy Detection
        │
        ▼
Secrets Found?
    │            │
   Yes          No
    │            │
Generate Report  Scan Passed
```

Gitleaks primarily uses:

* **Regular Expressions (Regex)** to match known secret patterns.
* **Entropy Analysis** to identify random-looking strings that may be secrets. ([GitHub][1])

---

# What Can Gitleaks Scan?

### 1. Git Repository

Scans the entire Git history.

```bash
gitleaks git
```

Example:

```bash
gitleaks git D:\terraform_repo
```

---

### 2. Directory

Scans only the current files.

```bash
gitleaks dir .
```

---

### 3. Single File

```bash
gitleaks dir terraform.tfvars
```

---

### 4. Standard Input

```bash
type terraform.tfvars | gitleaks stdin
```

---

# Common Secrets Detected

✅ AWS Access Keys

✅ Azure Credentials

✅ GitHub Tokens

✅ GitLab Tokens

✅ Slack Tokens

✅ Stripe Keys

✅ Google API Keys

✅ SSH Private Keys

✅ JWT Tokens

✅ Generic API Keys

---

# Example

Suppose your Terraform code contains:

```hcl
provider "azurerm" {
  features {}

  client_secret = "abcdefghijklmnopqrstuvwxyz123456789"
}
```

Running:

```bash
gitleaks dir .
```

may detect the secret because it matches a built-in rule.

---

# Why Your Password Was Not Detected

You tested:

```hcl
admin_password = "Devops@123"
```

By default, Gitleaks **did not report it** because:

* `admin_password` is a generic variable name.
* `"Devops@123"` does not match any built-in provider-specific secret pattern.
* Gitleaks avoids flagging every password-like string to reduce false positives.

When you created a custom `.gitleaks.toml` rule for `admin_password`, it correctly detected **2 leaks**.

---

# Custom Rules

Organizations often extend Gitleaks with custom rules.

Example:

```toml
[[rules]]
id = "terraform-admin-password"

description = "Terraform admin password"

regex = '''admin_password\s*=\s*"[^"]+"'''
```

Run:

```bash
gitleaks dir . --config .gitleaks.toml
```

Now every hardcoded Terraform admin password is detected.

---

# Report Formats

Gitleaks can generate reports in:

* JSON
* CSV
* JUnit
* SARIF (ideal for GitHub Security and Azure DevOps)

Example:

```bash
gitleaks dir . --report-format json --report-path report.json
```

---

# Integration in CI/CD

Gitleaks can run:

* Before every Git commit (pre-commit hook)
* GitHub Actions
* Azure DevOps Pipelines
* Jenkins
* GitLab CI/CD

Example workflow:

```text
Developer
     │
     ▼
Git Commit
     │
     ▼
Gitleaks Scan
     │
     ▼
Secrets Found?
     │
 ┌───┴────┐
 │        │
Yes       No
 │         │
Fail      Continue
 │         │
Fix Secret Deploy
```

---

# Advantages

* Fast scanning
* Open source
* Cross-platform (Windows, Linux, macOS)
* Supports Git history scanning
* Customizable rules
* Easy CI/CD integration
* Multiple report formats
* Helps meet security and compliance requirements ([GitHub][1])

---

# Limitations

* May not detect every hardcoded password with default rules.
* Can produce false positives without proper tuning.
* Needs custom rules for organization-specific secrets.
* Does not automatically remediate or encrypt exposed secrets.

---

# Gitleaks vs Other DevSecOps Tools

| Tool              | Purpose                                                        |
| ----------------- | -------------------------------------------------------------- |
| **Gitleaks**      | Detects secrets (passwords, API keys, tokens)                  |
| **TruffleHog**    | Secret scanning using regex and entropy, including Git history |
| **TFLint**        | Terraform code quality and best-practice checks                |
| **tfsec / Trivy** | Terraform security misconfiguration scanning                   |
| **Checkov**       | Infrastructure as Code security and compliance                 |
| **Terrascan**     | Policy-as-code validation for IaC                              |

---

# Interview Questions

### Q1. What is Gitleaks?

**Answer:** Gitleaks is an open-source DevSecOps tool that scans Git repositories, directories, and files to detect hardcoded secrets such as passwords, API keys, tokens, and cloud credentials using regex- and entropy-based detection.

### Q2. What is the difference between `gitleaks git` and `gitleaks dir`?

* `gitleaks git` scans the **Git commit history**.
* `gitleaks dir` scans the **current files** in a directory.

### Q3. Why didn't Gitleaks detect `admin_password = "Devops@123"`?

The default configuration targets known secret formats and high-confidence patterns. A generic password string doesn't necessarily match those rules. Creating a custom `.gitleaks.toml` rule allows detection of organization-specific secrets like Terraform `admin_password` values.

### Q4. Can Gitleaks be integrated into CI/CD?

Yes. It integrates with GitHub Actions, Azure DevOps, GitLab CI/CD, Jenkins, and pre-commit hooks to block commits or pipeline runs when secrets are detected. ([GitHub][1])
