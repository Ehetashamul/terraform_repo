
## Terraform Quick Revision

| Area | Remember |
|---|---|
| State | Remote, encrypted, locked, versioned/recoverable |
| Workflow | `init → fmt → validate → plan → apply` |
| Modules | Reusable code via variables + outputs |
| Dependencies | Prefer implicit references; use `depends_on` only when needed |
| Environments | Separate state; modules reused across Dev/QA/Stage/Prod |
| Security | Workload identity/managed identity + Key Vault + protected state |
| Drift | Detect with plan; decide whether code or external change is authoritative |

## Q1. 13 - create a storage account and write code for storing state file in blob storage …

**Asked in:** Creospan

**Answer:**

Create an Azure Storage Account and a Blob Container dedicated to Terraform state, then configure the `azurerm` backend in `terraform { backend "azurerm" { ... } }`. Enable appropriate storage security and versioning/soft-delete where supported, restrict access with RBAC/network controls, and use state locking provided by the backend. Run `terraform init` to initialize/migrate the backend.

## Q2. 1st round HCL question: what is module? what is provisioners? what is null resource? what is statefile? what is state locking in terraform? what is variable? write code with module and for_each; what is providers and write code; process to setup terraform; what is file provisioners; what is data variable?

**Asked in:** HCL

**Answer:**

This is a combined HCL round. I would explain each item briefly: **module** = reusable Terraform code; **provisioner** = runs commands/actions after resource creation and should be a last resort; **null_resource** = a legacy utility resource for triggering provisioner-based actions; **state file** = Terraform's record of managed objects and attributes; **state locking** prevents concurrent state writes; **variable** parameterizes configuration; **provider** is the plugin/API integration; **file provisioner** copies files; **data block** reads existing information without creating the resource. A typical setup is `terraform init` → `terraform fmt/validate` → `terraform plan` → `terraform apply`.

## Q3. A Terraform deployment failed midway, leaving the state file inconsistent while resources still exist in Azure. How would you handle this?

**Asked in:** Capgemini

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q4. A Terraform deployment is taking 1 hour. How would you optimize the deployment time?

**Asked in:** Infosys

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q5. After which command state file will be created.

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q6. Application team requests a new VM - end-to-end approach for provisioning using reusable Terraform modules and handing it over.

**Asked in:** Cognizant

**Answer:**

Gather requirements, validate standards, select the reusable VM module, prepare environment inputs, review dependencies/network/security, run fmt/validate/plan, obtain approval, apply through CI/CD, verify the VM and monitoring/backup/security configuration, then hand over IDs, access process, documentation and outputs. Keep the state in the correct remote backend.

## Q7. Are you following a modular Terraform approach?

**Asked in:** Impressico Business Solutions

**Answer:**

Use a thin environment/root module and reusable child modules. Example: `modules/{network,vm,aks,keyvault}` plus `env/{dev,qa,stage,prod}` roots. Pass inputs through variables, expose required values through outputs, pin module/provider versions, keep modules focused, and avoid embedding environment-specific values inside reusable modules.

## Q8. Can you explain the different variable types available in Terraform? When do you use each of them?

**Asked in:** LTIMindtree

**Answer:**

Terraform primitive types include `string`, `number`, and `bool`. Collection types include `list`, `set`, and `map`; structural types include `object` and `tuple`. Use explicit type constraints in variables so invalid inputs fail early.

## Q9. CI/CD & Terraform.

**Asked in:** Impressico Business Solutions

**Answer:**

Put Terraform in the infrastructure pipeline: checkout → authenticate → init → validate/lint/security scan → plan → approval → apply → outputs/verification. Keep credentials out of code, use remote state and locking, and separate plan/apply permissions for production.

## Q10. Create an identical Azure VM using Terraform, and write out the folder structure and scripts.

**Asked in:** Wissen Technology

**Answer:**

Use a reusable VM module with `for_each` over a map of VM definitions. Each key becomes a stable instance address and each value can contain size, image, subnet, disk, and naming inputs. Keep common logic in the module and environment-specific values in tfvars.

## Q11. Default value argument for a terraform variable.

**Asked in:** HCL

**Answer:**

Define it in the variable block with `default`. Example: `variable "location" { type = string default = "Central India" }`. If the caller supplies a value, that value overrides the default.

## Q12. Diff b/w for_each and count.

**Asked in:** HCL

**Answer:**

`count` creates instances addressed by numeric indexes (`resource.x[0]`), while `for_each` creates instances addressed by stable keys (`resource.x["web"]`). Use `count` for simple identical/conditional instances; use `for_each` when each instance has a meaningful key or different values. Deleting/reordering a `count` list can shift indexes and cause replacements, whereas stable `for_each` keys reduce that risk.

## Q13. Diff b/w root and child module.

**Asked in:** HCL

**Answer:**

The **root module** is the directory where Terraform is run; it composes the infrastructure and passes inputs to child modules. A **child module** is a reusable module called by another module. Example: root `prod/main.tf` calls `modules/vnet`, `modules/aks`, and `modules/keyvault`, passing variables and consuming outputs.

## Q14. Diff between count and for_each.

**Asked in:** HCL

**Answer:**

`count` creates instances addressed by numeric indexes (`resource.x[0]`), while `for_each` creates instances addressed by stable keys (`resource.x["web"]`). Use `count` for simple identical/conditional instances; use `for_each` when each instance has a meaningful key or different values. Deleting/reordering a `count` list can shift indexes and cause replacements, whereas stable `for_each` keys reduce that risk.

## Q15. Diff between pattern module and standard root child module.

**Asked in:** HCL

**Answer:**

A **resource module** packages one reusable capability such as a VM or VNet. A **pattern module** packages a larger opinionated architecture/pattern composed of several resources/modules. A **root module** is the deployment entry point for an environment; it calls child/resource modules and supplies environment-specific inputs.

## Q16. Difference between provider and provisioners ?

**Asked in:** HCL

**Answer:**

A **provider** is Terraform's plugin that talks to an API such as Azure, AWS, or GitHub and exposes resources/data sources. A **provisioner** executes a command or copies a file as part of resource lifecycle operations. Providers are fundamental to normal Terraform operation; provisioners are a last resort when the provider cannot model the required action.

## Q17. Difference between provider and provisioners.

**Asked in:** HCL

**Answer:**

A **provider** is Terraform's plugin that talks to an API such as Azure, AWS, or GitHub and exposes resources/data sources. A **provisioner** executes a command or copies a file as part of resource lifecycle operations. Providers are fundamental to normal Terraform operation; provisioners are a last resort when the provider cannot model the required action.

## Q18. Difference between Terraform Plan and Apply.

**Asked in:** Wipro

**Answer:**

`terraform plan` calculates and displays the proposed changes without applying them. `terraform apply` executes the approved plan against the target infrastructure. In CI/CD, a common pattern is to create a saved plan, review/approve it, then apply that exact plan.

## Q19. Difference between variable.tf and terraform.tfvars.

**Asked in:** HCL

**Answer:**

`variables.tf` (or any `.tf` file) normally contains variable **declarations**, including type, description, and optional default. `terraform.tfvars`/`.tfvars` contains **values** for those variables. Keep reusable declarations in code and environment-specific values in separate tfvars files or CI/CD variable inputs.

## Q20. Difference between variable.tf and variables.tf tfvars files.

**Asked in:** HCL

**Answer:**

`variables.tf` (or any `.tf` file) normally contains variable **declarations**, including type, description, and optional default. `terraform.tfvars`/`.tfvars` contains **values** for those variables. Keep reusable declarations in code and environment-specific values in separate tfvars files or CI/CD variable inputs.

## Q21. Draw and explain your Terraform reusable module structure for AKS.

**Asked in:** Deloitte

**Answer:**

A typical structure is `root/dev/main.tf` → `modules/aks/main.tf`. The AKS module receives inputs such as `name`, `location`, `resource_group_name`, `kubernetes_version`, `node_pools`, and network settings. It exposes outputs such as `cluster_id`, `kube_config`, or API server information (only expose sensitive values when necessary). Keep environment values in tfvars and keep the module generic.

## Q22. During deployment, Terraform accidentally deleted the Application Gateway.

**Asked in:** DXC

**Answer:**

First stop further applies and determine whether the deletion was caused by Terraform or an external/manual action. Inspect the plan, pipeline logs and state. If the resource was deleted in Azure but still exists in state, Terraform will normally plan to recreate it. If the state is wrong, recover from the remote-state version/backup or reconcile state carefully. Prevent recurrence with `prevent_destroy`, approvals, policy/RBAC and protected production pipelines.

## Q23. Example of recently upgraded templates in terraform.

**Asked in:** HCL

**Answer:**

Give a real example such as upgrading a shared module/provider version: review changelog and breaking changes, pin the target versions, run `terraform init -upgrade`, `validate`, and plan in a non-production environment, review the plan, test, then promote through CI/CD. Never combine a version upgrade with unrelated infrastructure changes.

## Q24. Explain a real-time Terraform deployment failure you resolved.

**Asked in:** TCS

**Answer:**

Use STAR: **Situation**—the deployment failed; **Task**—restore safely; **Action**—check pipeline logs, provider/API error, state lock, credentials, dependencies and the last successful state; fix the root cause, run `terraform plan`, and apply only after review; **Result**—deployment completed and controls/runbook were improved. Avoid claiming a specific incident unless it actually happened in your project.

## Q25. Explain create_before_destroy.

**Asked in:** Deloitte

**Answer:**

`create_before_destroy = true` tells Terraform to create the replacement object before destroying the old one when replacement is required. It is useful for resources where downtime must be minimized, but it can fail if the platform requires unique names or has quota constraints.

## Q26. Explain one real-time Terraform issue you fixed recently.

**Asked in:** DXC

**Answer:**

Use STAR: **Situation**—the deployment failed; **Task**—restore safely; **Action**—check pipeline logs, provider/API error, state lock, credentials, dependencies and the last successful state; fix the root cause, run `terraform plan`, and apply only after review; **Result**—deployment completed and controls/runbook were improved. Avoid claiming a specific incident unless it actually happened in your project.

## Q27. Explain Terraform architecture.

**Asked in:** AccionLabs

**Answer:**

Terraform has configuration (`.tf` files), the Terraform CLI/core, providers, state/backend, and the target APIs. Terraform builds a dependency graph from configuration, refreshes/reads state, creates a plan, and asks providers to make the required API calls. The backend stores state and can provide collaboration/locking.

## Q28. Explain the depends_on meta-argument.

**Asked in:** Deloitte

**Answer:**

`depends_on` declares an explicit dependency when Terraform cannot infer it from an expression. Example: a resource may depend on a policy or configuration whose ID is not directly referenced. Prefer implicit dependencies through references because they are more precise; use `depends_on` only when there is a real ordering dependency.

## Q29. Explain the Terraform Import process.

**Asked in:** Cognizant

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q30. Explain your Terraform module architecture, including Root Modules and Child Modules.

**Asked in:** NAB, Quess

**Answer:**

The **root module** is the directory where Terraform is run; it composes the infrastructure and passes inputs to child modules. A **child module** is a reusable module called by another module. Example: root `prod/main.tf` calls `modules/vnet`, `modules/aks`, and `modules/keyvault`, passing variables and consuming outputs.

## Q31. Explain your Terraform project folder structure.

**Asked in:** Deloitte

**Answer:**

A practical structure is: `modules/` for reusable child modules; `env/dev`, `env/qa`, `env/prod` for root configurations; each environment has `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`, `backend.tf`, and `.tfvars` supplied securely. Keep CI/CD definitions in the repository and separate state per environment/workload.

## Q32. Explain your Terraform workflow.

**Asked in:** KPMG

**Answer:**

Typical workflow: write configuration → `terraform fmt` → `terraform init` → `terraform validate` → `terraform plan` → review/approval → `terraform apply` → verify outputs/state. In CI/CD, use a remote backend, authentication through workload identity/service principal as appropriate, saved plans where required, approvals for production, and controlled state access.

## Q33. Give one variable and one output from your AKS Terraform module.

**Asked in:** Capgemini

**Answer:**

A typical structure is `root/dev/main.tf` → `modules/aks/main.tf`. The AKS module receives inputs such as `name`, `location`, `resource_group_name`, `kubernetes_version`, `node_pools`, and network settings. It exposes outputs such as `cluster_id`, `kube_config`, or API server information (only expose sensitive values when necessary). Keep environment values in tfvars and keep the module generic.

## Q34. Have you created custom Terraform modules or built infrastructure from scratch?

**Asked in:** Cognizant

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q35. Have you worked with Azure Private Endpoints? Suppose a VM suddenly loses connectivity to a Storage Account over a Private Endpoint after a Terraform or network change. How would you troubleshoot the issue, including verifying Private DNS Zone resolution, NSGs, UDRs, firewall rules, port 443, and other network configurations?

**Asked in:** Cognizant

**Answer:**

Troubleshoot layer by layer: 1) confirm the VM and Storage Account are healthy; 2) verify Private Endpoint connection/state; 3) from the VM, check DNS resolution of the storage hostname and confirm it resolves to the private IP; 4) verify the Private DNS Zone and VNet link; 5) check NSGs/UDRs and any Azure Firewall rules; 6) verify outbound TCP 443; 7) inspect effective routes and network-interface diagnostics; 8) review recent Terraform/network changes. Then run a controlled connectivity test and compare with the last known-good configuration.

## Q36. Have you worked with Azure Verified Modules (AVM) or Cloud Adoption Framework (CAF) Terraform modules?

**Asked in:** Cognizant

**Answer:**

Azure Verified Modules (AVM) are Microsoft's standardized, reusable Terraform modules for Azure resources and patterns. In an interview, explain whether you used them, evaluated them, or built custom modules. A strong approach is to prefer a suitable verified module, pin its version, pass only required inputs, and wrap it with a thin internal module when organizational standards are needed.

## Q37. Have you worked with Terraform Modules?

**Asked in:** Cognizant

**Answer:**

Answer with your actual experience: explain which modules you used/built, their inputs/outputs, how environments consumed them, and how you versioned and tested them. A good module is reusable, focused, documented and not tightly coupled to one environment.

## Q38. Have you worked with the Output Block? Can you explain its importance with a practical example?

**Asked in:** LTIMindtree

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q39. How can existing Azure resources created manually be imported into Terraform?

**Asked in:** LTIMindtree

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q40. How can we save sensitive data in state file?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q41. How do Jenkins, Docker, Kubernetes, Terraform, Prometheus, and Grafana work together in a complete CI/CD pipeline?

**Asked in:** Infosys

**Answer:**

Jenkins can orchestrate the pipeline; Terraform provisions infrastructure; Docker builds/packages applications; Kubernetes/AKS runs them; Prometheus collects metrics; Grafana visualizes metrics/dashboards. A typical flow is Git commit → Jenkins build/test/scan → Terraform plan/apply for infrastructure → image build/push → Kubernetes deployment → monitoring/alerts.

## Q42. How do multiple Terraform modules communicate with each other using outputs, variables, and dependencies?

**Asked in:** Cognizant

**Answer:**

A child module receives values through input variables and exposes values through outputs. The root module connects them: `module.vnet.subnet_id` can be passed to `module.vm.subnet_id`. Terraform builds dependencies from those references automatically; use `depends_on` only for dependencies that cannot be expressed by a value reference.

## Q43. How do you bring existing, manually-created Azure VMs under Terraform management?

**Asked in:** Infosys

**Answer:**

Write matching Terraform configuration, identify the provider resource ID, import the existing object into the correct resource address, then run `terraform plan`. Reconcile configuration with the real resource until the plan is clean or contains only intentional changes. Import is state adoption; it does not automatically produce complete configuration.

## Q44. How do you create an AKS cluster using Terraform?

**Asked in:** Deloitte

**Answer:**

Use the `azurerm_kubernetes_cluster` resource, normally inside a reusable AKS module. Inputs include resource group, location, DNS prefix, identity, Kubernetes version, network profile, and node pools. Add monitoring, RBAC, private-cluster/networking, and secret-management settings according to requirements. Run `init` → `validate` → `plan` → `apply` through controlled CI/CD.

## Q45. How do you create multiple Azure VMs with the same configuration?

**Asked in:** Wissen Technology

**Answer:**

Use a reusable VM module with `for_each` over a map of VM definitions. Each key becomes a stable instance address and each value can contain size, image, subnet, disk, and naming inputs. Keep common logic in the module and environment-specific values in tfvars.

## Q46. How do you deploy application through terraform provisioning,?

**Asked in:** Cohere Health

**Answer:**

Terraform should primarily provision the infrastructure/platform needed by the application. Application deployment can then be handled by CI/CD, Helm, VM extensions or another deployment mechanism. If Terraform must trigger application deployment, keep it controlled and idempotent rather than embedding large deployment scripts in provisioners.

## Q47. How do you deploy changes using reusable Terraform modules?

**Asked in:** Deloitte

**Answer:**

Build a module around a stable interface: required inputs, optional inputs with sensible defaults, outputs, validation, documentation and versioning. Keep environment-specific values outside the module. Reuse the same module across environments by passing different inputs.

## Q48. How do you design reusable Terraform modules for multiple environments (Dev, UAT, Prod), and how can a single module be reused across all environments?

**Asked in:** Cognizant

**Answer:**

Use the same reusable modules with separate environment root configurations and separate state. Keep Dev/QA/Stage/Prod values in environment-specific inputs, use CI/CD promotion and approvals, and avoid sharing one state file across environments. Workspaces can be useful for simple variations, but separate roots/state are often clearer for strongly isolated production environments.

## Q49. How do you design reusable Terraform modules for multiple environments (Dev, UAT, Prod)?

**Asked in:** Cognizant

**Answer:**

Use the same reusable modules with separate environment root configurations and separate state. Keep Dev/QA/Stage/Prod values in environment-specific inputs, use CI/CD promotion and approvals, and avoid sharing one state file across environments. Workspaces can be useful for simple variations, but separate roots/state are often clearer for strongly isolated production environments.

## Q50. How do you detect and fix Infrastructure Drift?

**Asked in:** DXC

**Answer:**

Drift means real infrastructure differs from the Terraform configuration/state expectations because of manual changes, external automation, provider behavior, or other changes. Detect it with `terraform plan`/refresh behavior and monitoring. Decide whether Terraform or the external change is the intended source of truth, then either update code and apply, or apply Terraform to restore the declared configuration. Prevent it with RBAC, policy, CI/CD-only changes, and monitoring.

## Q51. How do you encrypt the state file?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q52. How do you handle multiple Azure Subscription IDs in Terraform?

**Asked in:** Wissen Technology

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q53. How do you implement security in Terraform-based AKS deployments?

**Asked in:** Deloitte

**Answer:**

Use least-privilege RBAC, managed/workload identities, private networking where required, secure node pools, network policies, Key Vault integration for secrets, image scanning, policy/security scanning in CI/CD, encrypted/remote state, and restricted Terraform permissions. Protect production with approvals and `prevent_destroy` where appropriate.

## Q54. How do you import an existing Azure VM into Terraform?

**Asked in:** Capgemini, Wissen Technology

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q55. How do you integrate Terraform with Azure DevOps?

**Asked in:** Wipro

**Answer:**

A typical Azure DevOps flow is: checkout code → install/select Terraform → authenticate to Azure using a secure service connection/workload identity → `terraform init` against the remote backend → `fmt`/`validate` → `plan` → publish the plan for review → approved `apply`. Use secure variable handling, backend locking, approvals and separate state per environment.

## Q56. How do you manage multiple environments in Terraform?

**Asked in:** Deloitte

**Answer:**

Use the same reusable modules with separate environment root configurations and separate state. Keep Dev/QA/Stage/Prod values in environment-specific inputs, use CI/CD promotion and approvals, and avoid sharing one state file across environments. Workspaces can be useful for simple variations, but separate roots/state are often clearer for strongly isolated production environments.

## Q57. How do you manage Terraform across Dev, QA, and Production?

**Asked in:** TCS

**Answer:**

Use the same reusable modules with separate environment root configurations and separate state. Keep Dev/QA/Stage/Prod values in environment-specific inputs, use CI/CD promotion and approvals, and avoid sharing one state file across environments. Workspaces can be useful for simple variations, but separate roots/state are often clearer for strongly isolated production environments.

## Q58. How do you manage Terraform State Files?

**Asked in:** KPMG

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q59. How do you manage the Terraform state file in your project?

**Asked in:** Accenture

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q60. How do you migrate Terraform local state to a remote backend?

**Asked in:** Deloitte

**Answer:**

Use a remote backend such as Azure Blob Storage for Azure workloads. It centralizes state, supports team access and locking, and allows backup/versioning controls. Separate state by environment/workload, restrict backend access, enable encryption and recovery features, and initialize with `terraform init`.

## Q61. How do you monitor Terraform deployment failures?

**Asked in:** TCS

**Answer:**

Start with the pipeline logs and Terraform error output. Check `init`, authentication, backend/lock, provider/API errors, quota/throttling, dependency failures and the last successful state. Inspect `terraform plan` after fixing the root cause. Never blindly rerun production apply when the state or resource outcome is uncertain.

## Q62. How do you organize reusable Terraform modules?

**Asked in:** Deloitte

**Answer:**

Build a module around a stable interface: required inputs, optional inputs with sensible defaults, outputs, validation, documentation and versioning. Keep environment-specific values outside the module. Reuse the same module across environments by passing different inputs.

## Q63. How do you prevent accidental deletion of production VMs?

**Asked in:** Capgemini, Wissen Technology

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q64. How do you prevent infrastructure drift?

**Asked in:** Deloitte

**Answer:**

Drift means real infrastructure differs from the Terraform configuration/state expectations because of manual changes, external automation, provider behavior, or other changes. Detect it with `terraform plan`/refresh behavior and monitoring. Decide whether Terraform or the external change is the intended source of truth, then either update code and apply, or apply Terraform to restore the declared configuration. Prevent it with RBAC, policy, CI/CD-only changes, and monitoring.

## Q65. How do you protect production resources in Terraform? Show a lifecycle block.

**Asked in:** Capgemini, Wissen Technology

**Answer:**

The `lifecycle` block controls resource lifecycle behavior. Common arguments are `create_before_destroy`, `prevent_destroy`, and `ignore_changes`. Example: `lifecycle { prevent_destroy = true }` protects a critical resource; `ignore_changes` should be used carefully because it intentionally tells Terraform not to reconcile selected attributes.

## Q66. How do you recover a deleted Terraform State File?

**Asked in:** Wipro

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q67. How do you resolve Terraform Drift?

**Asked in:** Deloitte

**Answer:**

Drift means real infrastructure differs from the Terraform configuration/state expectations because of manual changes, external automation, provider behavior, or other changes. Detect it with `terraform plan`/refresh behavior and monitoring. Decide whether Terraform or the external change is the intended source of truth, then either update code and apply, or apply Terraform to restore the declared configuration. Prevent it with RBAC, policy, CI/CD-only changes, and monitoring.

## Q68. How do you securely manage sensitive information (passwords, keys, certs) in Terraform, integrate Azure Key Vault?

**Asked in:** Cognizant

**Answer:**

Do not hardcode credentials. Prefer workload identity/federated authentication for CI/CD and secret stores such as Azure Key Vault for application secrets. If Terraform must consume a secret, pass it through secure pipeline variables or a data source/secret integration and mark outputs sensitive. Remember that values may still enter state, so protect the state backend.

## Q69. How do you securely manage sensitive information such as passwords, keys, and certificates in Terraform, and how do you integrate Azure Key Vault?

**Asked in:** Cognizant

**Answer:**

Do not hardcode credentials. Prefer workload identity/federated authentication for CI/CD and secret stores such as Azure Key Vault for application secrets. If Terraform must consume a secret, pass it through secure pipeline variables or a data source/secret integration and mark outputs sensitive. Remember that values may still enter state, so protect the state backend.

## Q70. How do you structure Terraform code for Dev, QA, Stage, and Production environments?

**Asked in:** Deloitte

**Answer:**

Use the same reusable modules with separate environment root configurations and separate state. Keep Dev/QA/Stage/Prod values in environment-specific inputs, use CI/CD promotion and approvals, and avoid sharing one state file across environments. Workspaces can be useful for simple variations, but separate roots/state are often clearer for strongly isolated production environments.

## Q71. How do you structure Terraform projects using root and child modules, build own or reuse existing?

**Asked in:** Cognizant

**Answer:**

The **root module** is the directory where Terraform is run; it composes the infrastructure and passes inputs to child modules. A **child module** is a reusable module called by another module. Example: root `prod/main.tf` calls `modules/vnet`, `modules/aks`, and `modules/keyvault`, passing variables and consuming outputs.

## Q72. How do you structure your Terraform projects using root and child modules, and do you build your own modules or reuse existing ones?

**Asked in:** Cognizant

**Answer:**

The **root module** is the directory where Terraform is run; it composes the infrastructure and passes inputs to child modules. A **child module** is a reusable module called by another module. Example: root `prod/main.tf` calls `modules/vnet`, `modules/aks`, and `modules/keyvault`, passing variables and consuming outputs.

## Q73. How do you troubleshoot a failed Terraform deployment? (Step by step)?

**Asked in:** DXC

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q74. How do you use secrets in Terraform.?

**Asked in:** LTIMindtree

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q75. How does Terraform identify resource dependencies?

**Asked in:** Infosys, Wissen Technology

**Answer:**

Terraform dependencies are relationships that determine ordering. Most are implicit, created by references between resources. Explicit dependencies use `depends_on` when no attribute reference expresses the real dependency.

## Q76. How does Terraform State Locking work?

**Asked in:** TCS

**Answer:**

State locking prevents two Terraform operations from writing the same state concurrently. With an AzureRM backend, locking is handled through the backend. If a lock is genuinely stale, first verify no Terraform run is active; only then use `terraform force-unlock <LOCK_ID>` with care. Never force-unlock an active operation because it can cause concurrent state changes.

## Q77. How does the Terraform state file work in an enterprise environment?

**Asked in:** DXC

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q78. How is Terraform state managed in Terraform Enterprise?

**Asked in:** NAB, Quess

**Answer:**

Terraform Enterprise manages state centrally for workspaces, with access control, locking and workspace-level operations. Engineers use the TFE/TFC workflow rather than passing local state files around. Recovery and governance should use the platform's supported state/version mechanisms.

## Q79. How is the process to setup the terraform??

**Asked in:** HCL

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q80. How many reusable Terraform modules have you built?

**Asked in:** Capgemini

**Answer:**

Answer with your real number and examples. A strong response is: “I have built/reused X modules, for example VNet, VM, Key Vault and AKS. Each module has clear inputs/outputs, versioning and environment-independent logic.” Do not invent a number in an interview.

## Q81. How many variable types exist in Terraform?

**Asked in:** Wissen Technology

**Answer:**

Terraform primitive types include `string`, `number`, and `bool`. Collection types include `list`, `set`, and `map`; structural types include `object` and `tuple`. Use explicit type constraints in variables so invalid inputs fail early.

## Q82. How structure Terraform code using root modules, child modules, locals.tf, for_each, tfvars to follow DRY principle?

**Asked in:** Cognizant

**Answer:**

The **root module** is the directory where Terraform is run; it composes the infrastructure and passes inputs to child modules. A **child module** is a reusable module called by another module. Example: root `prod/main.tf` calls `modules/vnet`, `modules/aks`, and `modules/keyvault`, passing variables and consuming outputs.

## Q83. How to backend communicate with database?

**Asked in:** Creospan

**Answer:**

Terraform's **backend does not normally communicate with your application database**. The backend stores Terraform state. If the question means application-to-database communication, that is an infrastructure/network/application design concern and can be represented by Terraform resources, but Terraform itself is not the runtime data path.

## Q84. How to create 10 storage account in 10 subscription with single pipeline?

**Asked in:** HCL

**Answer:**

Use a map/list of subscription-specific configuration and provider aliases or a controlled multi-subscription deployment strategy. Iterate over the configuration with `for_each` where provider constraints allow, or invoke environment/subscription-specific pipeline jobs. Keep each subscription's state isolated and use secure authentication.

## Q85. How to manage state file?

**Asked in:** Creospan

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q86. How will you manage multiple environments using Terraform and CI/CD?

**Asked in:** TCS

**Answer:**

Use the same reusable modules with separate environment root configurations and separate state. Keep Dev/QA/Stage/Prod values in environment-specific inputs, use CI/CD promotion and approvals, and avoid sharing one state file across environments. Workspaces can be useful for simple variations, but separate roots/state are often clearer for strongly isolated production environments.

## Q87. How would you connect terraform to CI cd pipeline.

**Asked in:** LTIMindtree

**Answer:**

Put Terraform in the infrastructure pipeline: checkout → authenticate → init → validate/lint/security scan → plan → approval → apply → outputs/verification. Keep credentials out of code, use remote state and locking, and separate plan/apply permissions for production.

## Q88. How would you design reusable Terraform modules for a large enterprise?

**Asked in:** NAB, Quess

**Answer:**

Build a module around a stable interface: required inputs, optional inputs with sensible defaults, outputs, validation, documentation and versioning. Keep environment-specific values outside the module. Reuse the same module across environments by passing different inputs.

## Q89. How would you import existing Azure resources into Terraform so they can be managed as Infrastructure as Code?

**Asked in:** Cognizant

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q90. How would you import existing Azure resources into Terraform?

**Asked in:** Cognizant

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q91. How would you import existing cloud resources into Terraform?

**Asked in:** NAB, Quess

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q92. How would you import existing cloud resources into Terraform? What is the purpose of the Terraform Import Block?

**Asked in:** NAB

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q93. How would you migrate existing ClickOps infrastructure to Infrastructure as Code using Terraform?

**Asked in:** NAB, Quess

**Answer:**

Inventory the existing resources, classify dependencies, write matching Terraform configuration, import each resource into the correct address, run plans to reconcile configuration, and roll out in small batches. Freeze or control manual changes during migration and keep a rollback/recovery plan.

## Q94. How would you migrate infrastructure across multiple AWS/Azure accounts using Terraform?

**Asked in:** NAB, Quess

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q95. How would you migrate manually created Azure resources into Terraform?

**Asked in:** Cognizant

**Answer:**

Inventory the existing resources, classify dependencies, write matching Terraform configuration, import each resource into the correct address, run plans to reconcile configuration, and roll out in small batches. Freeze or control manual changes during migration and keep a rollback/recovery plan.

## Q96. How would you plan and execute a Terraform version upgrade (e.g., 0.x to 1.x), compatibility checks?

**Asked in:** Cognizant

**Answer:**

Check the current Terraform/provider/module versions, review changelogs and compatibility constraints, create a backup, test in a non-production environment, pin the target versions, run `terraform init -upgrade`, `terraform validate`, and `terraform plan`, review any replacements, then promote through CI/CD. Avoid mixing the upgrade with unrelated infrastructure changes.

## Q97. How would you plan and execute a Terraform version upgrade (e.g., from 0.x to 1.x), and what compatibility checks would you perform before upgrading?

**Asked in:** Cognizant

**Answer:**

Check the current Terraform/provider/module versions, review changelogs and compatibility constraints, create a backup, test in a non-production environment, pin the target versions, run `terraform init -upgrade`, `terraform validate`, and `terraform plan`, review any replacements, then promote through CI/CD. Avoid mixing the upgrade with unrelated infrastructure changes.

## Q98. How would you resolve a locked Terraform state when using Terraform Enterprise without Terraform installed locally?

**Asked in:** NAB, Quess

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q99. How would you standardize Terraform code across 20+ cloud accounts?

**Asked in:** NAB, Quess

**Answer:**

Create reusable modules and a common repository structure, pin Terraform/provider/module versions, enforce formatting/validation/lint/security checks, standardize naming/tags, centralize policy, and use CI/CD templates. Keep account/subscription-specific values outside the shared module code.

## Q100. How would you structure your Terraform code using root modules, child modules, locals.tf, for_each, and tfvars to follow the DRY (Don't Repeat Yourself) principle, so that common resources (Key Vault, Recovery Services Vault, Resource Group, etc.) don't need to be defined for every VM?

**Asked in:** Cognizant

**Answer:**

The **root module** is the directory where Terraform is run; it composes the infrastructure and passes inputs to child modules. A **child module** is a reusable module called by another module. Example: root `prod/main.tf` calls `modules/vnet`, `modules/aks`, and `modules/keyvault`, passing variables and consuming outputs.

## Q101. If I have a terraform code till vm or I applied terraform plan and apply but I what vm result in json format , what will be the command for it , tell me the command only

**Asked in:** HCL

**Answer:**

`terraform plan` calculates and displays the proposed changes without applying them. `terraform apply` executes the approved plan against the target infrastructure. In CI/CD, a common pattern is to create a saved plan, review/approve it, then apply that exact plan.

## Q102. If one VM becomes corrupted after deployment, how would you redeploy only that VM using Terraform?

**Asked in:** Cognizant

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q103. If the Terraform state file gets corrupted, how would you recover it, and what are the best practices to protect the state file?

**Asked in:** Cognizant

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q104. If the Terraform state file gets corrupted, how would you recover it, best practices to protect state file?

**Asked in:** Cognizant

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q105. If you are creating data block it will be part of state file ?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q106. If you are creating data block, is it part of state file?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q107. If you can't use Azure Key Vault, where would you store credentials?

**Asked in:** Infosys

**Answer:**

Use the organization's approved secret manager or CI/CD secret store, such as a secure pipeline variable group, HashiCorp Vault, AWS Secrets Manager, or another enterprise vault. Avoid plain `.tfvars`, Git, or unencrypted files. Protect Terraform state as well.

## Q108. If you mark a variable as sensitive in terraform , if while doing tef state so how you will see this variable ....?

**Asked in:** HCL

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q109. If you mark a variable as sensitive in terraform, how will you see this variable in tfstate?

**Asked in:** HCL

**Answer:**

`sensitive = true` primarily redacts a value from normal CLI output; it does **not** mean the value is absent from state. If the provider stores the secret in state, the state can still contain it. Protect the state backend and access permissions. Use `terraform show -json`/state inspection only under controlled access, and do not treat `sensitive` as encryption.

## Q110. If you need temporary access to a Storage Account owned by another team, but they cannot grant you RBAC permissions, how would you securely access the Storage Account? Explain the use of SAS Tokens and when you would choose them over RBAC.

**Asked in:** Cognizant

**Answer:**

RBAC is preferred for durable identity-based access. If temporary access is required and RBAC cannot be granted, a tightly scoped, short-lived SAS can be used with only the necessary permissions and expiry. Store the SAS securely, never commit it, and revoke/expire it when no longer needed.

## Q111. If ypu mark a variable as sensitive in terraform , if while doing tef state so how you will see this variable ....?

**Asked in:** HCL

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q112. If ypu mark a varibale as sensative in terraform , if while doing tef state so how you will see this variable ....?

**Asked in:** HCL

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q113. In main.tf, how do you pass multiple Subscription IDs to a module?

**Asked in:** Wissen Technology

**Answer:**

Define provider configurations/aliases for the required subscriptions and pass the appropriate provider alias into modules. Keep subscription IDs as variables or secure pipeline inputs, not hardcoded secrets. For many subscriptions, use a data-driven environment/account structure and separate state where appropriate.

## Q114. In your project you mentioned reusable modules. What exactly do you mean by reusable modules and how have you implemented them?

**Asked in:** LTIMindtree

**Answer:**

Build a module around a stable interface: required inputs, optional inputs with sensible defaults, outputs, validation, documentation and versioning. Keep environment-specific values outside the module. Reuse the same module across environments by passing different inputs.

## Q115. Is Terraform the best IaC tool? Why do we use Terraform?

**Asked in:** TCS

**Answer:**

Terraform provides declarative, version-controlled and repeatable infrastructure provisioning, with dependency management, reusable modules, plan-before-apply workflow and multi-provider support. It also integrates well with CI/CD and policy/security tooling.

## Q116. Move block.

**Asked in:** HCL

**Answer:**

A `moved` block tells Terraform that a resource/module address changed without changing the real object. Example: `moved { from = azurerm_linux_virtual_machine.web to = module.vm.azurerm_linux_virtual_machine.this }`. Terraform updates the state address instead of planning destroy/create, provided the move is valid.

## Q117. Multiple teams deploy infrastructure into the same Azure subscription. How do you manage Terraform plan and state?

**Asked in:** Capgemini

**Answer:**

Partition state by environment/workload/team boundary, use a remote backend with locking, and restrict access through RBAC. Avoid a single giant state for unrelated teams because it increases blast radius and lock contention.

## Q118. Pattern module.

**Asked in:** HCL

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q119. Pipeline deployment fails because backend is inaccessible - how will you fix it?

**Asked in:** Wipro

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q120. Provisioners in terraform.

**Asked in:** HCL

**Answer:**

Provisioners run actions during resource lifecycle, such as `local-exec`, `remote-exec`, and `file`. They can bootstrap a machine or perform an action not supported by a provider, but they are a last resort because they can be less predictable and harder to make idempotent. Prefer cloud-init/custom data, images, configuration management, or provider resources when possible.

## Q121. Rate yourself in Terraform out of 10.

**Asked in:** DXC

**Answer:**

Give an honest rating tied to evidence. For example: “I would rate myself 7–8/10. I am comfortable with modules, state, AzureRM, environments, CI/CD and troubleshooting, and I am actively deepening advanced topics such as complex state migration and provider edge cases.” Adjust the number to your actual skill.

## Q122. Rate yourself on Terraform.

**Asked in:** Cognizant

**Answer:**

Give an honest rating tied to evidence. For example: “I would rate myself 7–8/10. I am comfortable with modules, state, AzureRM, environments, CI/CD and troubleshooting, and I am actively deepening advanced topics such as complex state migration and provider edge cases.” Adjust the number to your actual skill.

## Q123. Resource and pattern module.

**Asked in:** HCL

**Answer:**

A resource module wraps a focused resource/capability, such as a VNet or VM. A pattern module combines several modules/resources into an opinionated architecture, such as a three-tier application pattern. Both can be called by an environment root module.

## Q124. Resource Module.

**Asked in:** HCL

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q125. Statefile management.

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q126. Suppose a resource was created manually in Azure. How will you manage it using Terraform?

**Asked in:** Cognizant

**Answer:**

Write matching Terraform configuration, identify the provider resource ID, import the existing object into the correct resource address, then run `terraform plan`. Reconcile configuration with the real resource until the plan is clean or contains only intentional changes. Import is state adoption; it does not automatically produce complete configuration.

## Q127. Suppose an application team requests a new VM. What would be your end-to-end approach for provisioning the VM using reusable Terraform modules and handing it over to the application team?

**Asked in:** Cognizant

**Answer:**

Gather requirements, validate standards, select the reusable VM module, prepare environment inputs, review dependencies/network/security, run fmt/validate/plan, obtain approval, apply through CI/CD, verify the VM and monitoring/backup/security configuration, then hand over IDs, access process, documentation and outputs. Keep the state in the correct remote backend.

## Q128. Suppose an Azure resource has already been created manually outside Terraform. Now you want Terraform to manage that resource. How would you bring it under Terraform management?

**Asked in:** LTIMindtree

**Answer:**

Write matching Terraform configuration, identify the provider resource ID, import the existing object into the correct resource address, then run `terraform plan`. Reconcile configuration with the real resource until the plan is clean or contains only intentional changes. Import is state adoption; it does not automatically produce complete configuration.

## Q129. Suppose someone creates a resource manually in Azure Cloud and it is not present in the Terraform state file. How will you manage or import it?

**Asked in:** TCS

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q130. Team member accidentally exposed password in terraform template, checked into repo - you changed password on target resource - how ensure password removed from repo.

**Asked in:** HCL

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q131. Terrafom drift.

**Asked in:** Creospan

**Answer:**

Drift means real infrastructure differs from the Terraform configuration/state expectations because of manual changes, external automation, provider behavior, or other changes. Detect it with `terraform plan`/refresh behavior and monitoring. Decide whether Terraform or the external change is the intended source of truth, then either update code and apply, or apply Terraform to restore the declared configuration. Prevent it with RBAC, policy, CI/CD-only changes, and monitoring.

## Q132. Terraform config deploys VM using custom image; later update software in that image; what happens if you run terraform apply again?

**Asked in:** HCL

**Answer:**

If the image ID/version referenced by Terraform does not change, updating software inside the image source does not automatically change an already-created VM. If a new image version/ID is supplied and the VM resource treats it as a replacement-triggering change, Terraform may plan a VM replacement. Use immutable, versioned images for predictable deployments.

## Q133. Terraform dependencies.

**Asked in:** HCL

**Answer:**

Terraform dependencies are relationships that determine ordering. Most are implicit, created by references between resources. Explicit dependencies use `depends_on` when no attribute reference expresses the real dependency.

## Q134. Terraform deployment and infrastructure troubleshooting scenarios.

**Asked in:** TCS

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q135. Terraform fmt.

**Asked in:** HCL

**Answer:**

`terraform fmt` formats Terraform configuration into Terraform's canonical style. In CI, use `terraform fmt -check` to fail when committed code is not formatted.

## Q136. Terraform function ?

**Asked in:** HCL

**Answer:**

Terraform has built-in functions for transforming values, such as `length`, `concat`, `merge`, `lookup`, `try`, `coalesce`, `replace`, `split`, and `join`. Example: `lower(var.environment)` normalizes text. Functions help keep configuration dynamic without duplicating resource definitions.

## Q137. Terraform function.

**Asked in:** HCL

**Answer:**

Terraform has built-in functions for transforming values, such as `length`, `concat`, `merge`, `lookup`, `try`, `coalesce`, `replace`, `split`, and `join`. Example: `lower(var.environment)` normalizes text. Functions help keep configuration dynamic without duplicating resource definitions.

## Q138. Terraform provisioners.

**Asked in:** HCL

**Answer:**

Provisioners run actions during resource lifecycle, such as `local-exec`, `remote-exec`, and `file`. They can bootstrap a machine or perform an action not supported by a provider, but they are a last resort because they can be less predictable and harder to make idempotent. Prefer cloud-init/custom data, images, configuration management, or provider resources when possible.

## Q139. Terraform show.

**Asked in:** HCL

**Answer:**

`terraform show` displays the current state or a saved plan in human-readable form. Use `terraform show -json` when a machine-readable JSON representation is required.

## Q140. Terraform shows changes even though you didn’t modify the code - why?

**Asked in:** Deloitte

**Answer:**

`terraform show` displays the current state or a saved plan in human-readable form. Use `terraform show -json` when a machine-readable JSON representation is required.

## Q141. Terraform slug - new questions.

**Asked in:** HCL

**Answer:**

The handbook's wording “Terraform slug - new questions” does not provide enough context to identify a specific technical question. In an interview, ask the interviewer to clarify what they mean by “slug” rather than guessing.

## Q142. Terraform state file is corrupted in production.

**Asked in:** DXC

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q143. Terraform vm result in json format - command to use.

**Asked in:** HCL

**Answer:**

`terraform show -json`

## Q144. Terraform workspace and why used.

**Asked in:** HCL

**Answer:**

Terraform workspaces allow multiple state instances for the same configuration. They are useful when environments are genuinely identical and differ mainly by values. For large teams or strongly isolated Dev/QA/Prod environments, separate root folders/configurations and separate state are often easier to secure and reason about.

## Q145. Two engineers run Terraform Apply simultaneously on the same environment. What happens?

**Asked in:** TCS

**Answer:**

The remote backend's state lock should allow only one operation to modify state at a time. The other run should wait/fail because the state is locked. In CI/CD, also serialize production deployments where appropriate. Never bypass the lock just to make the second run proceed.

## Q146. Type Constraints in Terraform.

**Asked in:** HCL

**Answer:**

Terraform primitive types include `string`, `number`, and `bool`. Collection types include `list`, `set`, and `map`; structural types include `object` and `tuple`. Use explicit type constraints in variables so invalid inputs fail early.

## Q147. VM created via terraform, installed Microsoft office manually after; run terraform apply again - what happens (office removed or stays)?

**Asked in:** HCL

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q148. VM suddenly loses connectivity to Storage Account over Private Endpoint after Terraform/network change - troubleshoot Private DNS Zone, NSGs, UDRs, firewall rules, port 443.

**Asked in:** Cognizant

**Answer:**

Troubleshoot layer by layer: 1) confirm the VM and Storage Account are healthy; 2) verify Private Endpoint connection/state; 3) from the VM, check DNS resolution of the storage hostname and confirm it resolves to the private IP; 4) verify the Private DNS Zone and VNet link; 5) check NSGs/UDRs and any Azure Firewall rules; 6) verify outbound TCP 443; 7) inspect effective routes and network-interface diagnostics; 8) review recent Terraform/network changes. Then run a controlled connectivity test and compare with the last known-good configuration.

## Q149. VM template with powershell script joining vm to domain - which provisioner to use.

**Asked in:** HCL

**Answer:**

Provisioners run actions during resource lifecycle, such as `local-exec`, `remote-exec`, and `file`. They can bootstrap a machine or perform an action not supported by a provider, but they are a last resort because they can be less predictable and harder to make idempotent. Prefer cloud-init/custom data, images, configuration management, or provider resources when possible.

## Q150. What are data types in Terraform?

**Asked in:** HCL

**Answer:**

Terraform primitive types include `string`, `number`, and `bool`. Collection types include `list`, `set`, and `map`; structural types include `object` and `tuple`. Use explicit type constraints in variables so invalid inputs fail early.

## Q151. What are lifecycle rules in terraform (declared within resource block)?

**Asked in:** HCL

**Answer:**

The `lifecycle` block controls resource lifecycle behavior. Common arguments are `create_before_destroy`, `prevent_destroy`, and `ignore_changes`. Example: `lifecycle { prevent_destroy = true }` protects a critical resource; `ignore_changes` should be used carefully because it intentionally tells Terraform not to reconcile selected attributes.

## Q152. What are Terraform Workspaces, why are they used, what are their benefits, and when would you use them instead of separate environment folders?

**Asked in:** Cognizant

**Answer:**

Terraform workspaces allow multiple state instances for the same configuration. They are useful when environments are genuinely identical and differ mainly by values. For large teams or strongly isolated Dev/QA/Prod environments, separate root folders/configurations and separate state are often easier to secure and reason about.

## Q153. What are Terraform Workspaces, why used, benefits, when instead of separate environment folders?

**Asked in:** Cognizant

**Answer:**

Terraform workspaces allow multiple state instances for the same configuration. They are useful when environments are genuinely identical and differ mainly by values. For large teams or strongly isolated Dev/QA/Prod environments, separate root folders/configurations and separate state are often easier to secure and reason about.

## Q154. What are the different types of variables available in Terraform?

**Asked in:** LTIMindtree

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

## Q155. What are the types of Azure Storage Account?

**Asked in:** TCS

**Answer:**

For Azure Storage, Terraform can configure the storage account kind/SKU and services such as Blob, File, Queue and Table. In an interview, focus on the required account kind/SKU, redundancy (LRS/ZRS/GRS variants), access/security settings and lifecycle requirements rather than treating 'types' as only a Portal menu list.

## Q156. What backends are you familiar with?

**Asked in:** HCL

**Answer:**

Backends define where Terraform stores state and how state operations are coordinated. Common choices include AzureRM, S3, GCS, Terraform Cloud/Enterprise and local. For Azure projects, Azure Blob Storage with the AzureRM backend is a common enterprise choice.

## Q157. What challenges have you faced during Terraform upgrades or deployments?

**Asked in:** TCS

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q158. What data types are you familiar with in terraform?

**Asked in:** HCL

**Answer:**

Terraform primitive types include `string`, `number`, and `bool`. Collection types include `list`, `set`, and `map`; structural types include `object` and `tuple`. Use explicit type constraints in variables so invalid inputs fail early.

## Q159. What do you understand by Terraform attributes? Can you explain them with an example?

**Asked in:** LTIMindtree

**Answer:**

An attribute is a value exposed by a resource or data source, such as `azurerm_resource_group.rg.id` or a VM's `name`. Attributes can be used as inputs to other resources, which also creates implicit dependencies.

## Q160. What happens if someone manually changes a resource managed by Terraform?

**Asked in:** Wipro

**Answer:**

Write matching Terraform configuration, identify the provider resource ID, import the existing object into the correct resource address, then run `terraform plan`. Reconcile configuration with the real resource until the plan is clean or contains only intentional changes. Import is state adoption; it does not automatically produce complete configuration.

## Q161. What happens if someone manually changes an AWS resource managed by Terraform?

**Asked in:** Wipro

**Answer:**

Write matching Terraform configuration, identify the provider resource ID, import the existing object into the correct resource address, then run `terraform plan`. Reconcile configuration with the real resource until the plan is clean or contains only intentional changes. Import is state adoption; it does not automatically produce complete configuration.

## Q162. What happens if Terraform Apply fails after creating some resources?

**Asked in:** Wipro

**Answer:**

Terraform can successfully create some resources before a later operation fails. State is updated as successful operations are recorded. Fix the root cause, run `terraform plan` to see what remains, and apply again. Do not assume everything was rolled back.

## Q163. What is `depends_on` and when do you use it?

**Asked in:** Infosys, Wissen Technology

**Answer:**

`depends_on` declares an explicit dependency when Terraform cannot infer it from an expression. Example: a resource may depend on a policy or configuration whose ID is not directly referenced. Prefer implicit dependencies through references because they are more precise; use `depends_on` only when there is a real ordering dependency.

## Q164. What is `depends_on` in Terraform?

**Asked in:** Infosys, Wissen Technology

**Answer:**

`depends_on` declares an explicit dependency when Terraform cannot infer it from an expression. Example: a resource may depend on a policy or configuration whose ID is not directly referenced. Prefer implicit dependencies through references because they are more precise; use `depends_on` only when there is a real ordering dependency.

## Q165. What is a Terraform data block, and how do you use it to reference existing Azure resources in your code?

**Asked in:** Cognizant

**Answer:**

A `data` block reads existing information from a provider without creating the resource. Example: `data "azurerm_resource_group" "rg" { name = "shared-rg" }`, then use `data.azurerm_resource_group.rg.id`. Data source information can be recorded in state because Terraform needs it for planning, but the data block does not make Terraform the owner of that existing resource.

## Q166. What is a Terraform data block, how do you use it to reference existing Azure resources?

**Asked in:** Cognizant

**Answer:**

A `data` block reads existing information from a provider without creating the resource. Example: `data "azurerm_resource_group" "rg" { name = "shared-rg" }`, then use `data.azurerm_resource_group.rg.id`. Data source information can be recorded in state because Terraform needs it for planning, but the data block does not make Terraform the owner of that existing resource.

## Q167. What is Configuration Drift?

**Asked in:** Wipro

**Answer:**

Drift means real infrastructure differs from the Terraform configuration/state expectations because of manual changes, external automation, provider behavior, or other changes. Detect it with `terraform plan`/refresh behavior and monitoring. Decide whether Terraform or the external change is the intended source of truth, then either update code and apply, or apply Terraform to restore the declared configuration. Prevent it with RBAC, policy, CI/CD-only changes, and monitoring.

## Q168. What is data block In Terraform?

**Asked in:** HCL

**Answer:**

A `data` block reads existing information from a provider without creating the resource. Example: `data "azurerm_resource_group" "rg" { name = "shared-rg" }`, then use `data.azurerm_resource_group.rg.id`. Data source information can be recorded in state because Terraform needs it for planning, but the data block does not make Terraform the owner of that existing resource.

## Q169. What is data block?

**Asked in:** LTIMindtree

**Answer:**

A `data` block reads existing information from a provider without creating the resource. Example: `data "azurerm_resource_group" "rg" { name = "shared-rg" }`, then use `data.azurerm_resource_group.rg.id`. Data source information can be recorded in state because Terraform needs it for planning, but the data block does not make Terraform the owner of that existing resource.

## Q170. What is dependencies in terraform?

**Asked in:** HCL

**Answer:**

Terraform dependencies are relationships that determine ordering. Most are implicit, created by references between resources. Explicit dependencies use `depends_on` when no attribute reference expresses the real dependency.

## Q171. What is deta block In Terraform?

**Asked in:** HCL

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

## Q172. What is diff b/w root and child module?

**Asked in:** HCL

**Answer:**

The **root module** is the directory where Terraform is run; it composes the infrastructure and passes inputs to child modules. A **child module** is a reusable module called by another module. Example: root `prod/main.tf` calls `modules/vnet`, `modules/aks`, and `modules/keyvault`, passing variables and consuming outputs.

## Q173. What is file provisioners?

**Asked in:** HCL

**Answer:**

Provisioners run actions during resource lifecycle, such as `local-exec`, `remote-exec`, and `file`. They can bootstrap a machine or perform an action not supported by a provider, but they are a last resort because they can be less predictable and harder to make idempotent. Prefer cloud-init/custom data, images, configuration management, or provider resources when possible.

## Q174. What is Infrastructure Drift?

**Asked in:** DXC

**Answer:**

Drift means real infrastructure differs from the Terraform configuration/state expectations because of manual changes, external automation, provider behavior, or other changes. Detect it with `terraform plan`/refresh behavior and monitoring. Decide whether Terraform or the external change is the intended source of truth, then either update code and apply, or apply Terraform to restore the declared configuration. Prevent it with RBAC, policy, CI/CD-only changes, and monitoring.

## Q175. What is linter in terraform / task group / deployment group / ADO / sprint and work item?

**Asked in:** HCL

**Answer:**

TFLint is a Terraform linter that checks configuration for syntax/provider-related issues and best-practice rules beyond basic validation. A pipeline can run `terraform fmt -check`, `terraform validate`, TFLint, and security scanners such as Checkov/tfsec according to organizational policy.

## Q176. What is linter in terraform?

**Asked in:** HCL

**Answer:**

TFLint is a Terraform linter that checks configuration for syntax/provider-related issues and best-practice rules beyond basic validation. A pipeline can run `terraform fmt -check`, `terraform validate`, TFLint, and security scanners such as Checkov/tfsec according to organizational policy.

## Q177. What is linting? - TFLint?

**Asked in:** HCL

**Answer:**

TFLint is a Terraform linter that checks configuration for syntax/provider-related issues and best-practice rules beyond basic validation. A pipeline can run `terraform fmt -check`, `terraform validate`, TFLint, and security scanners such as Checkov/tfsec according to organizational policy.

## Q178. What is modules?

**Asked in:** HCL

**Answer:**

A Terraform module is a collection of Terraform configuration files managed as a reusable unit. The directory you run Terraform from is the root module; modules called from it are child modules. Modules reduce duplication and provide a stable interface through variables and outputs.

## Q179. What is move block?

**Asked in:** HCL

**Answer:**

A `moved` block tells Terraform that a resource/module address changed without changing the real object. Example: `moved { from = azurerm_linux_virtual_machine.web to = module.vm.azurerm_linux_virtual_machine.this }`. Terraform updates the state address instead of planning destroy/create, provided the move is valid.

## Q180. What is null resource?

**Asked in:** HCL

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

## Q181. What is output block and how you will pass this into pipeline?

**Asked in:** HCL

**Answer:**

An `output` exposes a value from a module/root module, such as a resource ID or endpoint. Example: `output "vm_id" { value = azurerm_linux_virtual_machine.vm.id }`. A parent module can consume a child output, and CI/CD can retrieve root outputs with `terraform output -json`. Mark sensitive outputs `sensitive = true` when appropriate.

## Q182. What is provider.tf?

**Asked in:** TCS

**Answer:**

`provider.tf` is only a naming convention; Terraform does not require that exact filename. It commonly contains the `terraform` block with `required_providers` and provider configurations. Terraform loads all `.tf` files in the directory together.

## Q183. What is provisioner / provisioners in terraform?

**Asked in:** HCL

**Answer:**

Provisioners run actions during resource lifecycle, such as `local-exec`, `remote-exec`, and `file`. They can bootstrap a machine or perform an action not supported by a provider, but they are a last resort because they can be less predictable and harder to make idempotent. Prefer cloud-init/custom data, images, configuration management, or provider resources when possible.

## Q184. What is provisioners?

**Asked in:** HCL

**Answer:**

Provisioners run actions during resource lifecycle, such as `local-exec`, `remote-exec`, and `file`. They can bootstrap a machine or perform an action not supported by a provider, but they are a last resort because they can be less predictable and harder to make idempotent. Prefer cloud-init/custom data, images, configuration management, or provider resources when possible.

## Q185. What is stage terraform download module and providers?

**Asked in:** HCL

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

## Q186. What is state file and where we will keep it?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q187. What is State Lock in Terraform, and why is it required?

**Asked in:** TCS

**Answer:**

State locking prevents two Terraform operations from writing the same state concurrently. With an AzureRM backend, locking is handled through the backend. If a lock is genuinely stale, first verify no Terraform run is active; only then use `terraform force-unlock <LOCK_ID>` with care. Never force-unlock an active operation because it can cause concurrent state changes.

## Q188. What is state locking in terraform?

**Asked in:** HCL, Expleo (30th July)

**Answer:**

State locking prevents two Terraform operations from writing the same state concurrently. With an AzureRM backend, locking is handled through the backend. If a lock is genuinely stale, first verify no Terraform run is active; only then use `terraform force-unlock <LOCK_ID>` with care. Never force-unlock an active operation because it can cause concurrent state changes.

## Q189. What is State Locking? Why do we need it?

**Asked in:** LTIMindtree

**Answer:**

State locking prevents two Terraform operations from writing the same state concurrently. With an AzureRM backend, locking is handled through the backend. If a lock is genuinely stale, first verify no Terraform run is active; only then use `terraform force-unlock <LOCK_ID>` with care. Never force-unlock an active operation because it can cause concurrent state changes.

## Q190. What is state-file?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q191. What is statefile and where kept?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q192. What is statefile and where we will keep it?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q193. What is statefile?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q194. What is Terraform Drift, and how do you detect and safely handle manual changes made through the Azure Portal before running terraform plan and terraform apply?

**Asked in:** Cognizant

**Answer:**

Drift means real infrastructure differs from the Terraform configuration/state expectations because of manual changes, external automation, provider behavior, or other changes. Detect it with `terraform plan`/refresh behavior and monitoring. Decide whether Terraform or the external change is the intended source of truth, then either update code and apply, or apply Terraform to restore the declared configuration. Prevent it with RBAC, policy, CI/CD-only changes, and monitoring.

## Q195. What is Terraform Drift, how detect and safely handle manual changes made through Azure Portal before plan/apply?

**Asked in:** Cognizant

**Answer:**

Drift means real infrastructure differs from the Terraform configuration/state expectations because of manual changes, external automation, provider behavior, or other changes. Detect it with `terraform plan`/refresh behavior and monitoring. Decide whether Terraform or the external change is the intended source of truth, then either update code and apply, or apply Terraform to restore the declared configuration. Prevent it with RBAC, policy, CI/CD-only changes, and monitoring.

## Q196. What is Terraform drift?

**Asked in:** AccionLabs, Deloitte, LTIMindtree

**Answer:**

Drift means real infrastructure differs from the Terraform configuration/state expectations because of manual changes, external automation, provider behavior, or other changes. Detect it with `terraform plan`/refresh behavior and monitoring. Decide whether Terraform or the external change is the intended source of truth, then either update code and apply, or apply Terraform to restore the declared configuration. Prevent it with RBAC, policy, CI/CD-only changes, and monitoring.

## Q197. What is Terraform State File?

**Asked in:** Wipro

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q198. What is Terraform State Locking, and how would you unlock a locked Terraform state?

**Asked in:** NAB, Quess

**Answer:**

State locking prevents two Terraform operations from writing the same state concurrently. With an AzureRM backend, locking is handled through the backend. If a lock is genuinely stale, first verify no Terraform run is active; only then use `terraform force-unlock <LOCK_ID>` with care. Never force-unlock an active operation because it can cause concurrent state changes.

## Q199. What is Terraform state locking?

**Asked in:** Accenture

**Answer:**

State locking prevents two Terraform operations from writing the same state concurrently. With an AzureRM backend, locking is handled through the backend. If a lock is genuinely stale, first verify no Terraform run is active; only then use `terraform force-unlock <LOCK_ID>` with care. Never force-unlock an active operation because it can cause concurrent state changes.

## Q200. What is Terraform state management, and why is it important?

**Asked in:** LTIMindtree

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q201. What is Terraform Taint?

**Asked in:** Wipro

**Answer:**

`terraform taint` was used to mark a resource for replacement on the next plan/apply. In modern Terraform, prefer `terraform apply -replace=resource.address`, which explicitly requests replacement for that operation. Use replacement only when there is a reason the existing object is unhealthy or must be recreated.

## Q202. What is Terraform Taint? (he asked "terraform taint")?

**Asked in:** Wipro

**Answer:**

`terraform taint` was used to mark a resource for replacement on the next plan/apply. In modern Terraform, prefer `terraform apply -replace=resource.address`, which explicitly requests replacement for that operation. Use replacement only when there is a reason the existing object is unhealthy or must be recreated.

## Q203. What is Terraform?

**Asked in:** TCS

**Answer:**

Terraform is a declarative Infrastructure as Code tool. You define desired infrastructure in configuration, Terraform builds a dependency graph, compares configuration with state/real infrastructure, creates a plan, and uses providers to make API changes. It supports reusable modules and multiple cloud providers.

## Q204. What is the `-parallelism` flag in Terraform?

**Asked in:** Infosys

**Answer:**

`-parallelism=N` limits the number of resource operations Terraform can perform concurrently; the default is designed for normal use. Lower it when APIs throttle or dependencies are heavy; increase it only after testing. It does not override dependency ordering.

## Q205. What is the best strategy for storing Terraform State remotely?

**Asked in:** KPMG

**Answer:**

Use a remote backend such as Azure Blob Storage for Azure workloads. It centralizes state, supports team access and locking, and allows backup/versioning controls. Separate state by environment/workload, restrict backend access, enable encryption and recovery features, and initialize with `terraform init`.

## Q206. What is the difference between `count` and `for_each`?

**Asked in:** Wissen Technology

**Answer:**

`count` creates instances addressed by numeric indexes (`resource.x[0]`), while `for_each` creates instances addressed by stable keys (`resource.x["web"]`). Use `count` for simple identical/conditional instances; use `for_each` when each instance has a meaningful key or different values. Deleting/reordering a `count` list can shift indexes and cause replacements, whereas stable `for_each` keys reduce that risk.

## Q207. What is the difference between AzureRM Provider and AzAPI Provider?

**Asked in:** Cognizant

**Answer:**

AzureRM is the standard Azure provider with typed Terraform resources for common Azure services. AzAPI is useful for Azure Resource Manager APIs/features that are not yet fully exposed by AzureRM or when you need direct ARM resource/API control. Prefer AzureRM when it supports the required capability; use AzAPI for gaps or specific ARM API needs.

## Q208. What is the difference between terraform plan and terraform apply?

**Asked in:** TCS, Expleo (30th July)

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

## Q209. What is the difference between the Terraform block (required_providers) and the Provider block?

**Asked in:** Cognizant

**Answer:**

The `terraform` block's `required_providers` declares which provider packages are required and their version/source constraints. The `provider` block configures a provider instance, such as Azure subscription, tenant or features. In short: **required_providers = what plugin/version; provider = how that plugin is configured**.

## Q210. What is the move block in Terraform? example?

**Asked in:** HCL

**Answer:**

A `moved` block tells Terraform that a resource/module address changed without changing the real object. Example: `moved { from = azurerm_linux_virtual_machine.web to = module.vm.azurerm_linux_virtual_machine.this }`. Terraform updates the state address instead of planning destroy/create, provided the move is valid.

## Q211. What is the purpose of null_resource in Terraform, and can you give a practical use case?

**Asked in:** Cognizant

**Answer:**

`null_resource` does not represent a real infrastructure object. It was commonly used to attach provisioners or trigger actions based on changes. Example use: invoke a local script after a change. Prefer a real provider resource or newer purpose-built mechanisms when available; don't use it as a general replacement for configuration management.

## Q212. What is the purpose of null_resource in Terraform, practical use case?

**Asked in:** Cognizant

**Answer:**

`null_resource` does not represent a real infrastructure object. It was commonly used to attach provisioners or trigger actions based on changes. Example use: invoke a local script after a change. Prefer a real provider resource or newer purpose-built mechanisms when available; don't use it as a general replacement for configuration management.

## Q213. What is the purpose of the Terraform Import Block?

**Asked in:** NAB, Quess

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q214. What is the Terraform State File?

**Asked in:** TCS

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q215. What is the Terraform State File? Why is it important?

**Asked in:** LTIMindtree

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q216. What is the Terraform workflow?

**Asked in:** Wipro

**Answer:**

Typical workflow: write configuration → `terraform fmt` → `terraform init` → `terraform validate` → `terraform plan` → review/approval → `terraform apply` → verify outputs/state. In CI/CD, use a remote backend, authentication through workload identity/service principal as appropriate, saved plans where required, approvals for production, and controlled state access.

## Q217. What is variable.tf and terraform.tf vars?

**Asked in:** HCL

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

## Q218. What is variable.tf and terraform.tfvars?

**Asked in:** HCL

**Answer:**

`variables.tf` (or any `.tf` file) normally contains variable **declarations**, including type, description, and optional default. `terraform.tfvars`/`.tfvars` contains **values** for those variables. Keep reusable declarations in code and environment-specific values in separate tfvars files or CI/CD variable inputs.

## Q219. What kinds of Terraform drift have you encountered?

**Asked in:** TCS

**Answer:**

Drift means real infrastructure differs from the Terraform configuration/state expectations because of manual changes, external automation, provider behavior, or other changes. Detect it with `terraform plan`/refresh behavior and monitoring. Decide whether Terraform or the external change is the intended source of truth, then either update code and apply, or apply Terraform to restore the declared configuration. Prevent it with RBAC, policy, CI/CD-only changes, and monitoring.

## Q220. What logging levels supported by Terraform?

**Asked in:** HCL

**Answer:**

Terraform supports logging through `TF_LOG`, with levels such as `TRACE`, `DEBUG`, `INFO`, `WARN`, and `ERROR`. Use verbose levels such as `TRACE` only for troubleshooting because logs can contain sensitive operational details.

## Q221. What other Terraform lifecycle arguments have you used?

**Asked in:** Capgemini

**Answer:**

The `lifecycle` block controls resource lifecycle behavior. Common arguments are `create_before_destroy`, `prevent_destroy`, and `ignore_changes`. Example: `lifecycle { prevent_destroy = true }` protects a critical resource; `ignore_changes` should be used carefully because it intentionally tells Terraform not to reconcile selected attributes.

## Q222. What Terraform modules have you worked on?

**Asked in:** Wissen Technology

**Answer:**

Answer from your real experience. Examples include VNet/network, VM, Key Vault, storage, AKS and monitoring modules. Explain inputs, outputs, versioning, environment reuse and testing rather than only listing module names.

## Q223. What will you do if someone deletes the statefile?

**Asked in:** NOBLEQ

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q224. When creating a Resource Group, VNet, Subnet, NIC, and VM, how does Terraform know the correct creation order?

**Asked in:** Infosys, Wissen Technology

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q225. When do we use a Data Block in Terraform? Can you explain it with a practical example?

**Asked in:** LTIMindtree

**Answer:**

A `data` block reads existing information from a provider without creating the resource. Example: `data "azurerm_resource_group" "rg" { name = "shared-rg" }`, then use `data.azurerm_resource_group.rg.id`. Data source information can be recorded in state because Terraform needs it for planning, but the data block does not make Terraform the owner of that existing resource.

## Q226. When should you use the AzAPI Provider?

**Asked in:** Cognizant

**Answer:**

Use AzAPI when the required Azure ARM resource/property/API is not available in the AzureRM provider, or when you need a newer Azure API capability before AzureRM supports it. Keep API versions explicit and test upgrades carefully.

## Q227. When Will the State File Be Created?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q228. When would you use terraform force-unlock? What precautions should you take?

**Asked in:** TCS

**Answer:**

Use `terraform force-unlock` only when you have verified that the lock is stale and no Terraform process is running. Confirm the lock ID, inspect pipeline/run history, and communicate before unlocking production. Removing an active lock can allow concurrent writes and corrupt state.

## Q229. Where do you store the Terraform state file?

**Asked in:** TCS

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q230. Which Azure services are you creating through Terraform?

**Asked in:** Impressico Business Solutions

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q231. Which command do you use to recover Terraform State?

**Asked in:** Wipro

**Answer:**

There is no universal single 'restore' command. For a remote backend, restore a prior backend/versioned state through the backend's recovery mechanism; for reconstruction use `terraform import`. `terraform state` commands help inspect/manipulate addresses, while `terraform force-unlock` only handles stale locks.

## Q232. Which files are required while importing existing resources into Terraform?

**Asked in:** Cognizant

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q233. Which Terraform command performs a dry run and dependency check?

**Asked in:** Wissen Technology

**Answer:**

`terraform plan` is the normal Terraform command for a dry-run style preview. It refreshes/reads current information as needed, evaluates the dependency graph, and shows proposed changes without applying them.

## Q234. Which Terraform commands are used to restore the state file?

**Asked in:** DXC

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q235. Which Terraform meta-arguments support key-value pairs - for_each, count, map, nested maps?

**Asked in:** Cognizant

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q236. Which Terraform meta-arguments support key-value pairs, and when would you use for_each, count, map, or nested maps?

**Asked in:** Cognizant

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q237. Which variables and outputs are commonly used in an AKS module?

**Asked in:** Capgemini

**Answer:**

A typical structure is `root/dev/main.tf` → `modules/aks/main.tf`. The AKS module receives inputs such as `name`, `location`, `resource_group_name`, `kubernetes_version`, `node_pools`, and network settings. It exposes outputs such as `cluster_id`, `kube_config`, or API server information (only expose sensitive values when necessary). Keep environment values in tfvars and keep the module generic.

## Q238. Why can't a child module directly access variables from the root module?

**Asked in:** Wissen Technology

**Answer:**

The **root module** is the directory where Terraform is run; it composes the infrastructure and passes inputs to child modules. A **child module** is a reusable module called by another module. Example: root `prod/main.tf` calls `modules/vnet`, `modules/aks`, and `modules/keyvault`, passing variables and consuming outputs.

## Q239. Why did the Terraform state become inconsistent?

**Asked in:** Capgemini

**Answer:**

Terraform provides declarative, version-controlled and repeatable infrastructure provisioning, with dependency management, reusable modules, plan-before-apply workflow and multi-provider support. It also integrates well with CI/CD and policy/security tooling.

## Q240. Why did you create separate frontend and backend subnets?

**Asked in:** Impressico Business Solutions

**Answer:**

Separate frontend and backend subnets provide network segmentation. Frontend resources can have different ingress/egress controls, while backend services such as databases can be isolated with stricter NSGs/routes. This improves security, blast-radius control and traffic-policy management.

## Q241. Why do we store the State File remotely?

**Asked in:** Wipro

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q242. Why is IaC tools like terraform, idempotent?

**Asked in:** LTIMindtree

**Answer:**

IaC is intended to be declarative and idempotent: applying the same configuration to infrastructure already matching that configuration should result in no unnecessary changes. Terraform compares configuration with state and observed infrastructure and plans only required changes.

## Q243. Why use `terraform import`?

**Asked in:** Capgemini

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q244. Why use a remote backend?

**Asked in:** Capgemini

**Answer:**

Use a remote backend such as Azure Blob Storage for Azure workloads. It centralizes state, supports team access and locking, and allows backup/versioning controls. Separate state by environment/workload, restrict backend access, enable encryption and recovery features, and initialize with `terraform init`.

## Q245. Why use reusable Terraform modules?

**Asked in:** Capgemini

**Answer:**

Build a module around a stable interface: required inputs, optional inputs with sensible defaults, outputs, validation, documentation and versioning. Keep environment-specific values outside the module. Reuse the same module across environments by passing different inputs.

## Q246. Write a code with the help of module and for_each?

**Asked in:** HCL

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q247. Write a Terraform import command for any Azure resource.

**Asked in:** Capgemini, Wissen Technology

**Answer:**

Import brings an existing resource under Terraform state management. First write configuration that matches the resource, identify its Terraform resource address and provider resource ID, then use `terraform import <address> <id>` or an `import` block, followed by `terraform plan` and reconciliation. Import updates state; it does not automatically generate a complete `.tf` configuration.

## Q248. Write examples of List, Set, Map, and Object variables in Terraform.

**Asked in:** Wissen Technology

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q249. You mentioned following Terraform best practices and modern implementation techniques. Can you explain some of those practices in detail?

**Asked in:** LTIMindtree

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

## Q250. You mentioned implementing an Azure Landing Zone in your project. Did you provision the complete Landing Zone architecture using Terraform?

**Asked in:** LTIMindtree

**Answer:**

Yes, Terraform can provision a Landing Zone by composing reusable modules for management/governance, networking, security, logging/monitoring and shared services. Explain the exact components you actually implemented and how the pipeline handled subscriptions, state, policy and approvals.

## Q251. Your Terraform code lives in GitHub. How would you secure sensitive credentials?

**Asked in:** Infosys

**Answer:**

Do not hardcode credentials. Prefer workload identity/federated authentication for CI/CD and secret stores such as Azure Key Vault for application secrets. If Terraform must consume a secret, pass it through secure pipeline variables or a data source/secret integration and mark outputs sensitive. Remember that values may still enter state, so protect the state backend.

## Q252. If you've written a Terraform configuration to deploy a virtual machine using a custom image, and you later update the software in that image, what will happen if you run terraform apply again?

**Asked in:** HCL

**Answer:**

If the image ID/version referenced by Terraform does not change, updating software inside the image source does not automatically change an already-created VM. If a new image version/ID is supplied and the VM resource treats it as a replacement-triggering change, Terraform may plan a VM replacement. Use immutable, versioned images for predictable deployments.

## Q253. is count only work on integers ?, why deleting in count is difficult

**Asked in:** HCL

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q254. Type Constraints in Terraform.?

**Asked in:** HCL

**Answer:**

Terraform primitive types include `string`, `number`, and `bool`. Collection types include `list`, `set`, and `map`; structural types include `object` and `tuple`. Use explicit type constraints in variables so invalid inputs fail early.

## Q255. What is life cycle block give 2-3 argument,can it work on storage account scenario?

**Asked in:** HCL

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

## Q256. What is the move block in Terraform? Can you provide an example?

**Asked in:** HCL

**Answer:**

A `moved` block tells Terraform that a resource/module address changed without changing the real object. Example: `moved { from = azurerm_linux_virtual_machine.web to = module.vm.azurerm_linux_virtual_machine.this }`. Terraform updates the state address instead of planning destroy/create, provided the move is valid.

## Q257. When Will the State File Be Created?

**Asked in:** HCL

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q258. Why do you use Terraform for creating infra and not any other tool?

**Asked in:** Cognizant (Off-role)

**Answer:**

Terraform is not universally the best IaC tool; it is a strong choice when you need a declarative, multi-provider, version-controlled workflow with a dependency graph and reusable modules. The final choice depends on cloud, team skills, ecosystem, governance and existing tooling.

## Q259. How will you recover a Terraform code for a resource which is deleted from the portal?

**Asked in:** Cognizant (Off-role)

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q260. Which resources can't you create from the Azure portal but can with Terraform?

**Asked in:** Cognizant (Off-role)

**Answer:**

The premise is not absolute: if an Azure capability is exposed through an API/provider, Terraform may be able to manage it even when the Azure Portal does not expose the same operation or combination. I would say Terraform's advantage is automation and repeatability, not a fixed list of resources that the Portal cannot create.

## Q261. Difference between terraform plan and terraform apply?

**Asked in:** Cognizant (Off-role)

**Answer:**

Answer this by explaining the Terraform concept, how it works in the dependency/state/plan model, and one practical production example. In an interview, keep the first answer concise and then expand with code or troubleshooting steps if the interviewer asks.

## Q262. If you want to use the same code which different applications can run and reuse, how will you do that?

**Asked in:** Cognizant (Off-role)

**Answer:**

Use reusable modules with input variables and outputs. The application/environment passes different values while the module code remains unchanged. For multiple instances, combine the module with `for_each` over a map of definitions.

## Q263. How do you follow a child-parent module approach to provision resources?

**Asked in:** Persistent (24-07-2026)

**Answer:**

Treat the root as the parent/composition layer and reusable modules as children. The parent passes variables to children and consumes their outputs. Keep shared logic in child modules and environment-specific composition in the root.

## Q264. What approach do you take to deploy Azure Key Vault? What do you pass in the code?

**Asked in:** Persistent (24-07-2026)

**Answer:**

Create Key Vault with Terraform, configure RBAC/access controls, networking/private endpoint as required, diagnostics and purge/recovery settings according to policy. Do not put secret values directly in `.tf` files. Pass names/IDs as variables and retrieve secrets through approved identity-based mechanisms.

## Q265. Suppose you have to create 50 Resource Groups — which approach would you follow to build it?

**Asked in:** Persistent (24-07-2026)

**Answer:**

Use a map of Resource Group definitions and `for_each`, ideally through a reusable resource-group module. This gives stable addresses, avoids copy-paste, and makes additions/removals data-driven.

## Q266. Suppose you run your code in CI-CD and it succeeds — if you run it again, what message do you get?

**Asked in:** Persistent (24-07-2026)

**Answer:**

If the infrastructure already matches the configuration, a second apply should normally report that there are no changes to apply. That is the expected idempotent behavior.

## Q267. Where do you store the state file remotely, and how do you pass it in code?

**Asked in:** Persistent (24-07-2026)

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q268. What is a Terraform state file?

**Asked in:** UST Global

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q269. How will you recover a Terraform state file?

**Asked in:** UST Global

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q270. Can you edit a Terraform state file?

**Asked in:** UST Global

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q271. What are Terraform modules?

**Asked in:** UST Global

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

## Q272. How will you automate your Azure networking using Terraform?

**Asked in:** Valulabs (28-07-2026)

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q273. Suppose you want to automate this using Terraform — what commands can you use?

**Asked in:** Valulabs (28-07-2026)

**Answer:**

Common commands are `terraform init`, `terraform fmt`, `terraform validate`, `terraform plan`, `terraform apply`, `terraform destroy` (with great care), `terraform state list/show/mv/rm`, and `terraform output`. In CI/CD, use plan/apply as the controlled deployment path.

## Q274. What is Terraform? Explain the Terraform workflow.

**Asked in:** Expleo (30th July)

**Answer:**

Typical workflow: write configuration → `terraform fmt` → `terraform init` → `terraform validate` → `terraform plan` → review/approval → `terraform apply` → verify outputs/state. In CI/CD, use a remote backend, authentication through workload identity/service principal as appropriate, saved plans where required, approvals for production, and controlled state access.

## Q275. Explain the Terraform lifecycle.

**Asked in:** Expleo (30th July)

**Answer:**

The `lifecycle` block controls resource lifecycle behavior. Common arguments are `create_before_destroy`, `prevent_destroy`, and `ignore_changes`. Example: `lifecycle { prevent_destroy = true }` protects a critical resource; `ignore_changes` should be used carefully because it intentionally tells Terraform not to reconcile selected attributes.

## Q276. What is the terraform taint command? When would you use it?

**Asked in:** Expleo (30th July)

**Answer:**

`terraform taint` was used to mark a resource for replacement on the next plan/apply. In modern Terraform, prefer `terraform apply -replace=resource.address`, which explicitly requests replacement for that operation. Use replacement only when there is a reason the existing object is unhealthy or must be recreated.

## Q277. How do you upgrade Terraform providers? Write the command.

**Asked in:** Expleo (30th July)

**Answer:**

Check the current Terraform/provider/module versions, review changelogs and compatibility constraints, create a backup, test in a non-production environment, pin the target versions, run `terraform init -upgrade`, `terraform validate`, and `terraform plan`, review any replacements, then promote through CI/CD. Avoid mixing the upgrade with unrelated infrastructure changes.

## Q278. How do you secure Terraform secrets?

**Asked in:** Expleo (30th July)

**Answer:**

Use managed identities/workload identity for authentication where possible; store application secrets in Azure Key Vault or another approved vault; inject only what is required through secure pipeline mechanisms; mark Terraform outputs sensitive; and protect remote state because Terraform may store secret values in it.

## Q279. What is remote state in Terraform?

**Asked in:** Expleo (30th July)

**Answer:**

Remote state stores Terraform state in a shared backend instead of on one engineer's laptop. It improves collaboration, centralizes access control, supports locking and recovery, and reduces the risk of state loss.

## Q280. Explain Terraform modules.

**Asked in:** Forvia Hella (Cloud Security Engineer)

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

## Q281. If a Terraform module changes from version 3 to version 4, how does Terraform know? How will you implement it, and what changes will you make?

**Asked in:** Forvia Hella (Cloud Security Engineer)

**Answer:**

Terraform knows the module version from the module source/version constraint and records the selected module package in `.terraform.lock.hcl` where applicable for providers, while module version selection is controlled by module constraints/source. Update the module version explicitly, run `terraform init`, review the changelog and `terraform plan`, then handle breaking input/output/resource-address changes.

## Q282. How would you move a resource from one Terraform state file to another?

**Asked in:** Forvia Hella (Cloud Security Engineer)

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q283. Explain the difference between terraform import and a Terraform data block.

**Asked in:** Forvia Hella (Cloud Security Engineer)

**Answer:**

A `data` block reads existing information from a provider without creating the resource. Example: `data "azurerm_resource_group" "rg" { name = "shared-rg" }`, then use `data.azurerm_resource_group.rg.id`. Data source information can be recorded in state because Terraform needs it for planning, but the data block does not make Terraform the owner of that existing resource.

## Q284. What infrastructure components are provisioned through your Terraform pipelines?

**Asked in:** Publicis Sapient (1st Round - 30-07-2026)

**Answer:**

Mention only components you actually provision. Typical Azure examples are resource groups, VNets/subnets, NSGs, route tables, private endpoints, storage, Key Vault, VMs, AKS, load balancers/application gateways and monitoring. Explain that Terraform pipelines provision them from version-controlled code through plan/approval/apply.

## Q285. What is the order of resource creation in your Terraform deployment?

**Asked in:** Publicis Sapient (1st Round - 30-07-2026)

**Answer:**

Terraform builds a dependency graph. Explicit references such as `subnet_id = azurerm_subnet.app.id` create implicit dependencies, so the subnet is created before the NIC/VM that needs it. Terraform parallelizes independent resources. `depends_on` is used only for dependencies Terraform cannot infer.

## Q286. What exactly will your Terraform code contain?

**Asked in:** Publicis Sapient (1st Round - 30-07-2026)

**Answer:**

It contains declarative configuration: `terraform`/provider requirements, provider configuration, resources, data sources, variables, locals, modules, outputs and lifecycle/meta-arguments. Environment-specific values belong in variables/tfvars or pipeline inputs; secrets should come from secure identity/secret mechanisms.

## Q287. How would you design your Terraform code for one-click Landing Zone deployment?

**Asked in:** Publicis Sapient (1st Round - 30-07-2026)

**Answer:**

Compose reusable modules for management groups/subscriptions, networking, security, logging/monitoring, policy and shared services. Parameterize environment/subscription inputs, use a remote backend, CI/CD validation and approvals, and make the pipeline able to execute init → validate → plan → approval → apply consistently.

## Q288. How would you structure Terraform code for multiple subscriptions?

**Asked in:** Publicis Sapient (1st Round - 30-07-2026)

**Answer:**

Define provider configurations/aliases for the required subscriptions and pass the appropriate provider alias into modules. Keep subscription IDs as variables or secure pipeline inputs, not hardcoded secrets. For many subscriptions, use a data-driven environment/account structure and separate state where appropriate.

## Q289. How would you authenticate Terraform across multiple Azure subscriptions?

**Asked in:** Publicis Sapient (1st Round - 30-07-2026)

**Answer:**

A strong interview approach is: understand the requirement and dependencies, inspect the current Terraform configuration/state and provider/API status, make the smallest controlled code change, run `terraform fmt`, `terraform validate`, and `terraform plan`, review the plan, apply through the approved CI/CD process, and verify the result. Protect state and credentials throughout.

## Q290. How would you manage Terraform remote state files for multiple subscriptions?

**Asked in:** Publicis Sapient (1st Round - 30-07-2026)

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q291. Explain how to remove the state file of a particular resource in Terraform.

**Asked in:** LTM (30-07-2026)

**Answer:**

Terraform state maps Terraform resource addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. In a team, keep it in a secure remote backend rather than committing `terraform.tfstate` to Git. Restrict access, enable encryption/versioning and recovery controls, and use locking to prevent concurrent writes.

## Q292. Explain state locking in Terraform.

**Asked in:** LTM (30-07-2026)

**Answer:**

State locking prevents two Terraform operations from writing the same state concurrently. With an AzureRM backend, locking is handled through the backend. If a lock is genuinely stale, first verify no Terraform run is active; only then use `terraform force-unlock <LOCK_ID>` with care. Never force-unlock an active operation because it can cause concurrent state changes.

## Q293. Share your screen and explain Terraform modules with iterations.

**Asked in:** LTM (30-07-2026)

**Answer:**

In Terraform, this should be explained in terms of **configuration → state → dependency graph → plan → provider/API execution**. Define the concept, give a small example, and mention one production best practice or caveat.

---

## Source coverage note

The attachment's master Terraform repository identifies 293 unique canonical questions. The extracted set was taken from that Terraform section rather than only one company's chapter, so it covers the cross-company Terraform question bank. The handbook's company chapters also contain Terraform questions such as state locking, drift, modules, import, lifecycle and remote state. fileciteturn1file0L10-L25