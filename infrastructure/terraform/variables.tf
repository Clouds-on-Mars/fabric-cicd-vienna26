# variables.tf - Input Variables for Fabric Infrastructure

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
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

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-fabric-workshop"
}

variable "capacity_sku" {
  description = "Fabric capacity SKU (F2, F4, F8, F16, F32, F64, F128, F256, F512, F1024, F2048)"
  type        = string
  default     = "F2"
  
  validation {
    condition     = can(regex("^F(2|4|8|16|32|64|128|256|512|1024|2048)$", var.capacity_sku))
    error_message = "Capacity SKU must be a valid F-SKU."
  }
}

variable "workspace_admins" {
  description = "List of admin principal IDs (users, groups, or service principals)"
  type        = list(string)
  default     = []
}

variable "create_capacity" {
  description = "Whether to create a new Fabric capacity (false = use existing)"
  type        = bool
  default     = true
}

variable "existing_capacity_id" {
  description = "ID of existing Fabric capacity (if create_capacity = false)"
  type        = string
  default     = ""
}

variable "git_provider" {
  description = "Git provider type (AzureDevOps or GitHub)"
  type        = string
  default     = "AzureDevOps"
  
  validation {
    condition     = contains(["AzureDevOps", "GitHub"], var.git_provider)
    error_message = "Git provider must be AzureDevOps or GitHub."
  }
}

variable "git_organization" {
  description = "Git organization/account name"
  type        = string
  default     = ""
}

variable "git_project" {
  description = "Git project name (Azure DevOps only, leave empty for GitHub)"
  type        = string
  default     = ""
}

variable "git_repository" {
  description = "Git repository name"
  type        = string
  default     = ""
}

variable "enable_git_integration" {
  description = "Whether to enable Git integration for workspaces"
  type        = bool
  default     = false
}

variable "git_connection_id" {
  description = "Pre-configured Git connection ID in Fabric (required for GitHub, optional for Azure DevOps with Automatic auth)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Workshop  = "Fabric-DE-CICD"
  }
}
