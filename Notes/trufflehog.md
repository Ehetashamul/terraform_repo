# TruffleHog (Secret Scanning Tool)

**TruffleHog** is an **open-source secret scanning tool** used to detect **hardcoded secrets, API keys, passwords, access tokens, SSH keys, private keys, and other sensitive credentials** that may have been accidentally committed to Git repositories or stored in files, cloud storage, CI/CD logs, and other sources. It can also **verify** many detected credentials to reduce false positives. ([Truffle Security][1])

---

# Why TruffleHog is Needed

Developers sometimes accidentally commit secrets like:

* AWS Access Keys
* Azure Service Principal Secrets
* GitHub Personal Access Tokens
* Docker Hub credentials
* Database passwords
* JWT tokens
* SSH private keys
* Slack tokens

If these secrets reach a Git repository (even if later deleted), attackers may retrieve them from the Git history.

TruffleHog scans repositories and histories to detect these leaked credentials before they are exploited. ([Truffle Security][1])

---

# What TruffleHog Can Scan

TruffleHog can scan:

* Git repositories (entire commit history)
* Local directories
* GitHub repositories
* GitLab repositories
* Bitbucket
* S3 buckets
* Docker images
* Filesystems
* CI/CD artifacts
* Wikis and collaboration platforms (Enterprise edition)

It supports detecting **800+ secret types**. ([Truffle Security][1])

---

# How TruffleHog Works

```text
Developer Code
       │
       ▼
Git Repository
       │
       ▼
TruffleHog Scanner
       │
       ▼
Detects Secrets
       │
       ▼
Verifies Credentials (when supported)
       │
       ▼
Security Report
```

Unlike antivirus software, TruffleHog specializes in finding exposed credentials.

---

# Installation

## Windows (using Scoop)

```powershell
scoop install trufflehog
```

## macOS

```bash
brew install trufflehog
```

## Linux

Download the latest release binary from the official GitHub releases page or install using your package manager if available. ([GitHub][2])

---

# Basic Commands

## Scan a Git Repository

```bash
trufflehog git https://github.com/user/repository.git
```

---

## Scan Current Directory

```bash
trufflehog filesystem .
```

---

## Scan a Local Git Repository

```bash
trufflehog git file:///C:/Projects/MyRepo
```

---

## Output as JSON

```bash
trufflehog filesystem . --json
```

---

# Example

## Insecure Code

```python
AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
```

Running:

```bash
trufflehog filesystem .
```

Sample output:

```text
Detector: AWS
Verified: true

File: config.py
Line: 2

Secret Found
```

---

# Supported Secret Types

TruffleHog detects:

* AWS Keys
* Azure Credentials
* Google Cloud Keys
* GitHub Tokens
* GitLab Tokens
* Slack Tokens
* Stripe Keys
* Twilio Tokens
* JWT Tokens
* SSH Private Keys
* RSA Keys
* PEM Certificates
* Database Credentials
* Kubernetes Secrets
* Docker Credentials

and hundreds more. ([Truffle Security][1])

---

# CI/CD Integration

A secure DevSecOps pipeline commonly looks like this:

```text
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
tfsec / Trivy
    │
    ▼
TruffleHog
    │
    ▼
Terraform plan
    │
    ▼
Terraform apply
```

TruffleHog helps ensure no sensitive credentials are committed before deployment.

---

# TruffleHog vs Gitleaks

| Feature            | TruffleHog | Gitleaks                    |
| ------------------ | ---------- | --------------------------- |
| Secret Detection   | ✅          | ✅                           |
| Git History Scan   | ✅          | ✅                           |
| Verify Credentials | ✅          | ❌ (primarily pattern-based) |
| 800+ Secret Types  | ✅          | Hundreds of rules           |
| Filesystem Scan    | ✅          | ✅                           |
| CI/CD Integration  | ✅          | ✅                           |
| Performance        | Moderate   | Very Fast                   |

---

# TruffleHog vs GitLeaks vs tfsec

| Tool                   | Purpose                                                                                               |
| ---------------------- | ----------------------------------------------------------------------------------------------------- |
| **Terraform Validate** | Checks Terraform syntax                                                                               |
| **TFLint**             | Terraform best practices and linting                                                                  |
| **tfsec / Trivy**      | Terraform security misconfigurations                                                                  |
| **Gitleaks**           | Detects hardcoded secrets using rules and patterns                                                    |
| **TruffleHog**         | Detects and verifies leaked credentials across repositories, filesystems, and other supported sources |

---

# DevOps Interview Questions

### Q1. What is TruffleHog?

**Answer:** TruffleHog is an open-source secret scanning tool that detects and, where possible, verifies exposed credentials such as API keys, passwords, and tokens in Git repositories, filesystems, cloud storage, and other supported sources. ([Truffle Security][1])

### Q2. What problem does TruffleHog solve?

**Answer:** It helps prevent accidental exposure of sensitive credentials that could be exploited if committed to source code or stored insecurely.

### Q3. What is the difference between TruffleHog and Gitleaks?

**Answer:** Both detect secrets, but TruffleHog can verify many detected credentials to reduce false positives, while Gitleaks primarily relies on pattern and rule-based detection.

### Q4. Does TruffleHog scan Git history?

**Answer:** Yes. It scans the complete commit history, not just the latest version of files. ([GitHub][3])

### Q5. Where is TruffleHog commonly used?

**Answer:** It is commonly integrated into GitHub Actions, Azure DevOps, GitLab CI/CD, Jenkins, pre-commit hooks, and other DevSecOps pipelines to prevent secrets from reaching production.

[1]: https://trufflesecurity.com/docs?utm_source=chatgpt.com "Choose your adventure - TruffleHog Docs"
[2]: https://github.com/trufflesecurity/trufflehog/releases?utm_source=chatgpt.com "Releases · trufflesecurity/trufflehog · GitHub"
[3]: https://github.com/Shopify/truffleHog-1?utm_source=chatgpt.com "GitHub - Shopify/truffleHog-1: Searches through git repositories for high entropy strings and secrets, digging deep into commit history · GitHub"
