# Fabric Infrastructure as Code with Terraform

This directory contains Terraform configurations for deploying Microsoft Fabric infrastructure.

## Structure

```
infrastructure/
├── module0-terraform.md  # Module 0: Terraform tutorial
└── terraform/
    ├── main.tf           # Provider configuration
    ├── variables.tf      # Input variables
    ├── workspaces.tf     # Fabric workspaces
    ├── capacity.tf       # Fabric capacity
    ├── security.tf       # Access control & service principals
    ├── git-integration.tf # Git repository connections
    ├── outputs.tf        # Output values
    └── terraform.tfvars.example  # Example variable values
```

## Quick Start

```bash
cd infrastructure/terraform

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Initialize
terraform init

# Plan
terraform plan -out=tfplan

# Apply
terraform apply tfplan
```

## Prerequisites

- Terraform >= 1.5.0
- Azure CLI authenticated
- Azure subscription with Fabric capacity permissions
- (Optional) Azure Storage Account for remote state

## Resources Created

| Resource | Description |
|----------|-------------|
| `fabric_workspace.dev` | Development workspace |
| `fabric_workspace.test` | Test workspace |
| `fabric_workspace.prod` | Production workspace |
| `azurerm_fabric_capacity.main` | Fabric F-SKU capacity |
| `azuread_service_principal.cicd` | CI/CD service principal |
| `fabric_workspace_role_assignment.*` | Workspace access |
| `fabric_workspace_git.*` | Git integration |

## Learn More

See [Module 0: Infrastructure as Code with Terraform](./module0-terraform.md) for the full tutorial.
