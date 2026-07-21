# Terraform Learning Repository

This repository contains hands-on Terraform practice files for building Azure infrastructure as code. It includes examples for resource creation, variables, backends, dependencies, loops, modules, and networking-related configurations.

## Repository Structure

The folders are organized by topic and date to reflect different learning stages:

- 00_RG: Basic resource group examples
- 01_Implicit_explicit_dependency_15Apr26: Dependency handling examples
- 02_Backend_Block_23Apr26: Backend configuration practice
- 03_Variable_28Apr26 to 05_Variable_02May26: Variable and .tfvars usage
- 06_for_each_03May26 to 09_for_each_map_nested_20May26: for_each and nested loop examples
- 10_LandingZone_Resource_for_each_nested_06June26 to 18_NIC_PIP_DataBlock_VMS_Module_21July26: Advanced resource, module, and networking examples

## What You Will Practice

- Terraform syntax and providers
- Variables and input files
- State management and backend setup
- Resource dependencies
- for_each and nested loops
- Reusable modules
- Azure networking and VM-related examples

## Getting Started

1. Install Terraform on your machine.
2. Navigate to any practice folder.
3. Run:
   - terraform init
   - terraform plan
   - terraform apply
4. When finished, remove resources with:
   - terraform destroy

## Notes

- Review provider authentication and environment settings before applying changes.
- Some examples may require Azure credentials and proper subscription access.
- Use these folders as learning references and adapt them for your own lab environment.

