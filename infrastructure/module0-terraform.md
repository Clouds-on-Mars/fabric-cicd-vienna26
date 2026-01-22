# Module 0: Infrastructure as Code with Terraform

> [!NOTE]
> **Difficulty:** Intermediate | [Next: Environment Setup →](../configuration/module1-environment-setup.md)

## Overview

Before deploying Fabric artifacts, enterprise teams need to provision the underlying infrastructure. This module covers using **Terraform** to deploy and manage Microsoft Fabric workspaces, capacities, and security configurations as code.

**Why Infrastructure as Code?**
- **Reproducibility**: Spin up identical environments on demand
- **Version Control**: Track infrastructure changes in Git
- **Automation**: Integrate with CI/CD pipelines
- **Compliance**: Enforce security policies consistently

## Learning Objectives

By the end of this module, you will:

- Understand the Microsoft Fabric Terraform provider
- Deploy Fabric workspaces using Terraform
- Configure capacity assignments programmatically
- Manage workspace security and access control
- Integrate Terraform with Azure DevOps pipelines

## Prerequisites

- Azure subscription with Fabric capacity
- Terraform CLI installed (v1.5+)
- Azure CLI installed and authenticated
- Basic understanding of Terraform concepts

## Part 1: Understanding Fabric Terraform Provider

### The Microsoft Fabric Provider

Microsoft provides an official Terraform provider for Fabric resources:

```hcl
terraform {
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = ">= 0.1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "fabric" {
  # Uses Azure CLI authentication by default
  preview = true  # Required for fabric_workspace_git resource
}

provider "azurerm" {
  features {}
  subscription_id = "your-subscription-id"  # Required - get from: az account show --query id -o tsv
}
```

> [!IMPORTANT]
> The `azurerm` provider requires an explicit `subscription_id`. Without it, you'll get the error:
> `subscription ID could not be determined and was not specified`

### Supported Resources

| Resource Type | Terraform Resource | Description |
|--------------|-------------------|-------------|
| Workspace | `fabric_workspace` | Create and manage workspaces |
| Capacity | `azurerm_fabric_capacity` | Provision F-SKU capacities |
| Workspace Role | `fabric_workspace_role_assignment` | Manage access control |
| Git Integration | `fabric_workspace_git` | Connect workspace to Git |
| Domain | `fabric_domain` | Organize workspaces |

## Part 2: Setting Up Terraform

### Step 2.1: Install Terraform

**macOS (Homebrew)**
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform --version
```

**Windows (Chocolatey)**
```powershell
choco install terraform
terraform --version
```

**Linux (Ubuntu/Debian)**
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### Step 2.2: Azure Authentication

```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "Your-Subscription-Name" 

e.g. az account set --subscription "VIENNA26" 



# Verify
az account show
```

## Part 3: Deploy Fabric Workspace

### Step 3.1: Create Terraform Configuration

Create a new directory for your infrastructure code:

```bash
mkdir -p infrastructure/terraform
cd infrastructure/terraform
```

Create `main.tf`:

```hcl
# main.tf - Fabric Workspace Infrastructure

terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = ">= 0.1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0"
    }
  }
}

provider "fabric" {
  preview = true  # Required for Git integration resources
}

provider "azurerm" {
  features {}
  # IMPORTANT: subscription_id is required
  # Get yours with: az account show --query id -o tsv
  subscription_id = "your-subscription-id"
}

provider "azuread" {}
```

> [!TIP]
> Get your subscription ID:
> ```bash
> az account show --query id -o tsv
> ```

Create `variables.tf`:

```hcl
# variables.tf - Input Variables

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "deworkshop"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "capacity_sku" {
  description = "Fabric capacity SKU"
  type        = string
  default     = "F2"
}

variable "workspace_admins" {
  description = "List of admin principal IDs"
  type        = list(string)
  default     = []
}

# For using existing capacity (e.g., Trial capacity)
variable "create_capacity" {
  description = "Whether to create a new capacity (false = use existing Trial/F-SKU)"
  type        = bool
  default     = false  # Set to false for Trial capacity
}

variable "existing_capacity_id" {
  description = "ID of existing capacity (find in Workspace Settings → License info)"
  type        = string
  default     = ""
}
```

> [!TIP]
> **Using a Trial Capacity?** Set `create_capacity = false` and provide your capacity ID:
> 1. Go to Fabric portal → any workspace → Workspace settings
> 2. Click **License info**
> 3. Copy the **Capacity ID** (e.g., `CE6C3F15-0103-4A3F-8010-5F28B2D219F4`)

Create `workspaces.tf`:

```hcl
# workspaces.tf - Fabric Workspaces

# Determine which capacity to use
locals {
  capacity_id = var.create_capacity ? azurerm_fabric_capacity.main[0].id : var.existing_capacity_id
}

# Development Workspace
resource "fabric_workspace" "dev" {
  display_name = "${var.project_name}_dev"
  description  = "Development workspace for ${var.project_name}"
  
  capacity_id = local.capacity_id
}

# Test Workspace
resource "fabric_workspace" "test" {
  display_name = "${var.project_name}_test"
  description  = "Test workspace for ${var.project_name}"
  
  capacity_id = local.capacity_id
}

# Production Workspace
resource "fabric_workspace" "prod" {
  display_name = "${var.project_name}_prod"
  description  = "Production workspace for ${var.project_name}"
  
  capacity_id = local.capacity_id
}
```

Create `capacity.tf`:

```hcl
# capacity.tf - Fabric Capacity
# Only needed if create_capacity = true (creating a new F-SKU capacity)

data "azurerm_resource_group" "fabric" {
  count = var.create_capacity ? 1 : 0
  name  = "rg-fabric-${var.environment}"
}

resource "azurerm_fabric_capacity" "main" {
  count = var.create_capacity ? 1 : 0
  
  name                = "fc${var.project_name}${var.environment}"
  resource_group_name = data.azurerm_resource_group.fabric[0].name
  location            = var.location
  
  sku {
    name = var.capacity_sku
    tier = "Fabric"
  }
  
  administration_members = var.workspace_admins
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
```

Create `security.tf`:

```hcl
# security.tf - Workspace Security

# Get current user for admin assignment
data "azuread_client_config" "current" {}

# NOTE: Workspace creators are automatically assigned as Admin.
# The role assignments below will fail with "PrincipalAlreadyHasWorkspaceRolePermissions"
# if the current user created the workspaces. This is expected behavior.
# Uncomment these only if you need to add OTHER users as admins.

# # Workspace Admin Role Assignment - Development
# resource "fabric_workspace_role_assignment" "dev_admin" {
#   workspace_id = fabric_workspace.dev.id
#   principal = {
#     id   = data.azuread_client_config.current.object_id
#     type = "User"
#   }
#   role = "Admin"
# }

# # Workspace Admin Role Assignment - Test  
# resource "fabric_workspace_role_assignment" "test_admin" { ... }

# # Workspace Admin Role Assignment - Production
# resource "fabric_workspace_role_assignment" "prod_admin" { ... }

# Service Principal for CI/CD
resource "azuread_application" "cicd" {
  display_name = "sp-${var.project_name}-cicd"
}

resource "azuread_service_principal" "cicd" {
  client_id = azuread_application.cicd.client_id
}

resource "azuread_service_principal_password" "cicd" {
  service_principal_id = azuread_service_principal.cicd.id
  end_date             = timeadd(timestamp(), "8760h") # 1 year from now

  lifecycle {
    ignore_changes = [end_date]  # Prevent recreation on each apply
  }
}

# Grant CI/CD Service Principal access to all workspaces
resource "fabric_workspace_role_assignment" "cicd_dev" {
  workspace_id = fabric_workspace.dev.id
  principal = {
    id   = azuread_service_principal.cicd.object_id
    type = "ServicePrincipal"
  }
  role = "Admin"
}

resource "fabric_workspace_role_assignment" "cicd_test" {
  workspace_id = fabric_workspace.test.id
  principal = {
    id   = azuread_service_principal.cicd.object_id
    type = "ServicePrincipal"
  }
  role = "Admin"
}

resource "fabric_workspace_role_assignment" "cicd_prod" {
  workspace_id = fabric_workspace.prod.id
  principal = {
    id   = azuread_service_principal.cicd.object_id
    type = "ServicePrincipal"
  }
  role = "Admin"
}
```

Create `outputs.tf`:

```hcl
# outputs.tf - Output Values

output "workspace_ids" {
  description = "Workspace IDs for each environment"
  value = {
    dev  = fabric_workspace.dev.id
    test = fabric_workspace.test.id
    prod = fabric_workspace.prod.id
  }
}

output "capacity_id" {
  description = "Fabric capacity ID"
  value       = azurerm_fabric_capacity.main.id
}

output "service_principal" {
  description = "CI/CD Service Principal details"
  value = {
    client_id     = azuread_application.cicd.client_id
    object_id     = azuread_service_principal.cicd.object_id
    client_secret = azuread_service_principal_password.cicd.value
  }
  sensitive = true
}
```

### Step 3.2: Create terraform.tfvars

Create `terraform.tfvars` to configure your deployment:

**Option A: Using Trial Capacity (recommended for workshop)**
```hcl
# terraform.tfvars - Workshop Configuration (Trial Capacity)

environment   = "dev"
project_name  = "deworkshop"
location      = "westeurope"

# Use existing Trial capacity (don't create new)
create_capacity      = false
existing_capacity_id = "YOUR-CAPACITY-ID"  # From Workspace Settings → License info
```

**Option B: Creating New F-SKU Capacity**
```hcl
# terraform.tfvars - Production Configuration (New Capacity)

environment         = "dev"
project_name        = "deworkshop"
location            = "westeurope"
resource_group_name = "rg-fabric-workshop"

create_capacity = true
capacity_sku    = "F2"
```

### Step 3.3: Initialize and Apply

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan
```

> [!WARNING]
> **Expected Role Assignment Errors:** If you see `PrincipalAlreadyHasWorkspaceRolePermissions` errors during apply, this is expected. Workspace creators are automatically Admin, so Terraform can't add the same permission again. The workspaces are still created successfully.

### Step 3.4: Verify Deployment

```bash
# Show outputs
terraform output

# Show specific workspace
terraform state show fabric_workspace.dev

# Get service principal secret for CI/CD
terraform output -raw service_principal_client_secret
```

## Part 4: Git Integration via Terraform

Connect workspaces to Git repositories:

Create `git-integration.tf`:

```hcl
# git-integration.tf - Workspace Git Configuration

variable "git_provider" {
  description = "Git provider (AzureDevOps or GitHub)"
  type        = string
  default     = "AzureDevOps"
}

variable "git_organization" {
  description = "Git organization/account name"
  type        = string
}

variable "git_project" {
  description = "Git project name (Azure DevOps only)"
  type        = string
  default     = ""
}

variable "git_repository" {
  description = "Git repository name"
  type        = string
}

variable "git_connection_id" {
  description = "Pre-configured Git connection ID (required for GitHub)"
  type        = string
  default     = null
}

# Development workspace - main branch
resource "fabric_workspace_git" "dev" {
  workspace_id = fabric_workspace.dev.id
  
  git_provider_details = {
    git_provider_type = var.git_provider
    # Azure DevOps specific
    organization_name = var.git_provider == "AzureDevOps" ? var.git_organization : null
    project_name      = var.git_provider == "AzureDevOps" ? var.git_project : null
    # GitHub specific  
    owner_name        = var.git_provider == "GitHub" ? var.git_organization : null
    # Common
    repository_name   = var.git_repository
    branch_name       = "main"
    directory_name    = "/"
  }
  
  git_credentials = {
    source        = var.git_connection_id != null ? "ConfiguredConnection" : "Automatic"
    connection_id = var.git_connection_id
  }
  
  initialization_strategy = "PreferWorkspace"
}

# Test workspace - test branch
resource "fabric_workspace_git" "test" {
  workspace_id = fabric_workspace.test.id
  
  git_provider_details = {
    git_provider_type = var.git_provider
    organization_name = var.git_provider == "AzureDevOps" ? var.git_organization : null
    project_name      = var.git_provider == "AzureDevOps" ? var.git_project : null
    owner_name        = var.git_provider == "GitHub" ? var.git_organization : null
    repository_name   = var.git_repository
    branch_name       = "test"
    directory_name    = "/"
  }
  
  git_credentials = {
    source        = var.git_connection_id != null ? "ConfiguredConnection" : "Automatic"
    connection_id = var.git_connection_id
  }
  
  initialization_strategy = "PreferRemote"
}

# Production workspace - production branch
resource "fabric_workspace_git" "prod" {
  workspace_id = fabric_workspace.prod.id
  
  git_provider_details = {
    git_provider_type = var.git_provider
    organization_name = var.git_provider == "AzureDevOps" ? var.git_organization : null
    project_name      = var.git_provider == "AzureDevOps" ? var.git_project : null
    owner_name        = var.git_provider == "GitHub" ? var.git_organization : null
    repository_name   = var.git_repository
    branch_name       = "production"
    directory_name    = "/"
  }
  
  git_credentials = {
    source        = var.git_connection_id != null ? "ConfiguredConnection" : "Automatic"
    connection_id = var.git_connection_id
  }
  
  initialization_strategy = "PreferRemote"
}
```

> **Important**: The `fabric_workspace_git` resource requires preview mode enabled in the provider configuration. Add `preview = true` to your fabric provider block.

## Part 5: CI/CD Pipeline Integration

### Azure DevOps Pipeline for Terraform

Create `.azdo/terraform-deploy.yml`:

```yaml
# terraform-deploy.yml - Infrastructure Deployment Pipeline

trigger:
  branches:
    include:
      - main
  paths:
    include:
      - infrastructure/terraform/**

pool:
  vmImage: 'ubuntu-latest'

variables:
  - group: fabric-terraform-secrets
  - name: TF_VAR_environment
    value: 'dev'

stages:
  - stage: Validate
    displayName: 'Validate Terraform'
    jobs:
      - job: Validate
        steps:
          - task: TerraformInstaller@1
            displayName: 'Install Terraform'
            inputs:
              terraformVersion: 'latest'
          
          - task: TerraformTaskV4@4
            displayName: 'Terraform Init'
            inputs:
              provider: 'azurerm'
              command: 'init'
              workingDirectory: 'infrastructure/terraform'
              backendServiceArm: 'AzureServiceConnection'
              backendAzureRmResourceGroupName: 'rg-terraform-state'
              backendAzureRmStorageAccountName: 'stterraformstate'
              backendAzureRmContainerName: 'tfstate'
              backendAzureRmKey: 'fabric-workshop.tfstate'
          
          - task: TerraformTaskV4@4
            displayName: 'Terraform Validate'
            inputs:
              provider: 'azurerm'
              command: 'validate'
              workingDirectory: 'infrastructure/terraform'

  - stage: Plan
    displayName: 'Plan Infrastructure'
    dependsOn: Validate
    jobs:
      - job: Plan
        steps:
          - task: TerraformInstaller@1
            inputs:
              terraformVersion: 'latest'
          
          - task: TerraformTaskV4@4
            displayName: 'Terraform Init'
            inputs:
              provider: 'azurerm'
              command: 'init'
              workingDirectory: 'infrastructure/terraform'
              backendServiceArm: 'AzureServiceConnection'
              backendAzureRmResourceGroupName: 'rg-terraform-state'
              backendAzureRmStorageAccountName: 'stterraformstate'
              backendAzureRmContainerName: 'tfstate'
              backendAzureRmKey: 'fabric-workshop.tfstate'
          
          - task: TerraformTaskV4@4
            displayName: 'Terraform Plan'
            inputs:
              provider: 'azurerm'
              command: 'plan'
              workingDirectory: 'infrastructure/terraform'
              environmentServiceNameAzureRM: 'AzureServiceConnection'
              commandOptions: '-out=tfplan'
          
          - task: PublishPipelineArtifact@1
            displayName: 'Publish Plan'
            inputs:
              targetPath: 'infrastructure/terraform/tfplan'
              artifact: 'terraform-plan'

  - stage: Apply
    displayName: 'Apply Infrastructure'
    dependsOn: Plan
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: Apply
        environment: 'fabric-infrastructure'
        strategy:
          runOnce:
            deploy:
              steps:
                - task: TerraformInstaller@1
                  inputs:
                    terraformVersion: 'latest'
                
                - task: DownloadPipelineArtifact@2
                  inputs:
                    artifact: 'terraform-plan'
                    path: 'infrastructure/terraform'
                
                - task: TerraformTaskV4@4
                  displayName: 'Terraform Init'
                  inputs:
                    provider: 'azurerm'
                    command: 'init'
                    workingDirectory: 'infrastructure/terraform'
                    backendServiceArm: 'AzureServiceConnection'
                    backendAzureRmResourceGroupName: 'rg-terraform-state'
                    backendAzureRmStorageAccountName: 'stterraformstate'
                    backendAzureRmContainerName: 'tfstate'
                    backendAzureRmKey: 'fabric-workshop.tfstate'
                
                - task: TerraformTaskV4@4
                  displayName: 'Terraform Apply'
                  inputs:
                    provider: 'azurerm'
                    command: 'apply'
                    workingDirectory: 'infrastructure/terraform'
                    environmentServiceNameAzureRM: 'AzureServiceConnection'
                    commandOptions: 'tfplan'
```

## Part 6: Best Practices

### State Management

Always use remote state for team collaboration:

```hcl
# backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate"
    container_name       = "tfstate"
    key                  = "fabric-workshop.tfstate"
  }
}
```

### Environment Separation

Use workspaces or separate state files:

```bash
# Using Terraform workspaces
terraform workspace new dev
terraform workspace new test
terraform workspace new prod

# Switch workspace
terraform workspace select dev
terraform apply -var="environment=dev"
```

### Security Recommendations

1. **Never commit secrets** — Use Azure Key Vault or environment variables
2. **Use Service Principals** — Avoid personal credentials in pipelines
3. **Enable state locking** — Prevent concurrent modifications
4. **Review plans carefully** — Especially for destructive changes

## Checkpoint

Before continuing, verify:

- [ ] Terraform CLI installed (`terraform --version`)
- [ ] Azure CLI authenticated (`az account show`)
- [ ] Understand Fabric Terraform provider resources
- [ ] Know how to deploy workspaces via Terraform
- [ ] Understand security and state management

## Summary

You've learned how to:
- ✅ Set up Terraform for Microsoft Fabric
- ✅ Deploy workspaces, capacities, and security configurations
- ✅ Configure Git integration via Terraform
- ✅ Integrate Terraform with CI/CD pipelines
- Apply infrastructure as code best practices

---

## Resync if You're Behind (Module 0)

If your Terraform setup isn't working:

1. **Check Terraform is installed**
   ```bash
   terraform --version
   ```
   - Should show version 1.5.0 or later

2. **Check Azure CLI authentication**
   ```bash
   az account show
   ```
   - If not logged in, run `az login`

3. **Reinitialize Terraform**
   ```bash
   cd infrastructure/terraform
   terraform init
   ```

4. **Check for common errors**

   | Error | Solution |
   |-------|----------|
   | `subscription ID could not be determined` | Add `subscription_id` to the `azurerm` provider block |
   | `Resource Group was not found` | Set `create_capacity = false` and use `existing_capacity_id` for Trial capacity |
   | `PrincipalAlreadyHasWorkspaceRolePermissions` | This is expected — workspace creators are auto-admin. Workspaces were created successfully. |

5. **Get your subscription ID**
   ```bash
   az account show --query id -o tsv
   ```

6. **Find your Trial capacity ID**
   - Fabric portal → any workspace → Workspace settings → License info
   - Copy the Capacity ID (e.g., `CE6C3F15-0103-4A3F-8010-5F28B2D219F4`)

Still not working? This module is **optional** — you can skip to [Module 1](../configuration/module1-environment-setup.md) and return later.

---

## What You Learned in Module 0

By completing this module, you:

- ✅ Installed and configured the **Terraform CLI** for Azure
- ✅ Understood the **Microsoft Fabric Terraform provider** resources
- ✅ Deployed Fabric **workspaces and capacities** via Infrastructure as Code
- ✅ Configured **Git integration** for workspaces programmatically
- ✅ Learned **best practices** for state management and security
- ✅ Explored **CI/CD pipeline integration** for Terraform automation

---

| [Home](../README.md) | [Module 1: Environment Setup →](../configuration/module1-environment-setup.md) |
|:---------------------|-----------------------------------------------------------:|
