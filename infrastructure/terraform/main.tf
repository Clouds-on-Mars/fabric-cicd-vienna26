# main.tf - Fabric Workspace Infrastructure
# Microsoft Fabric Terraform Provider Configuration

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
  
  # Uncomment for remote state (recommended for teams)
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "stterraformstate"
  #   container_name       = "tfstate"
  #   key                  = "fabric-workshop.tfstate"
  # }
}

# Fabric provider - uses Azure CLI authentication by default
# Preview mode enabled for fabric_workspace_git resource
provider "fabric" {
  preview = true
}

# Azure Resource Manager provider
provider "azurerm" {
  features {}
}

# Azure Active Directory provider
provider "azuread" {}
