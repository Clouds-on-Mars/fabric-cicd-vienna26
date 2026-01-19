# outputs.tf - Output Values

# -----------------------------------------
# Workspace Outputs
# -----------------------------------------

output "workspace_ids" {
  description = "Workspace IDs for each environment"
  value = {
    dev  = fabric_workspace.dev.id
    test = fabric_workspace.test.id
    prod = fabric_workspace.prod.id
  }
}

output "workspace_names" {
  description = "Workspace display names"
  value = {
    dev  = fabric_workspace.dev.display_name
    test = fabric_workspace.test.display_name
    prod = fabric_workspace.prod.display_name
  }
}

# -----------------------------------------
# Capacity Outputs
# -----------------------------------------

output "capacity_id" {
  description = "Fabric capacity ID"
  value       = var.create_capacity ? azurerm_fabric_capacity.main[0].id : var.existing_capacity_id
}

output "capacity_name" {
  description = "Fabric capacity name"
  value       = var.create_capacity ? azurerm_fabric_capacity.main[0].name : "existing-capacity"
}

# -----------------------------------------
# Service Principal Outputs
# -----------------------------------------

output "service_principal_client_id" {
  description = "CI/CD Service Principal Client ID (Application ID)"
  value       = azuread_application.cicd.client_id
}

output "service_principal_object_id" {
  description = "CI/CD Service Principal Object ID"
  value       = azuread_service_principal.cicd.object_id
}

output "service_principal_client_secret" {
  description = "CI/CD Service Principal Client Secret"
  value       = azuread_service_principal_password.cicd.value
  sensitive   = true
}

output "tenant_id" {
  description = "Azure AD Tenant ID"
  value       = data.azuread_client_config.current.tenant_id
}

# -----------------------------------------
# Connection Strings for CI/CD
# -----------------------------------------

output "cicd_connection_info" {
  description = "Connection information for CI/CD pipelines"
  value = {
    tenant_id     = data.azuread_client_config.current.tenant_id
    client_id     = azuread_application.cicd.client_id
    workspace_dev = fabric_workspace.dev.id
    workspace_test = fabric_workspace.test.id
    workspace_prod = fabric_workspace.prod.id
  }
}

# -----------------------------------------
# Git Integration Outputs
# -----------------------------------------

output "git_integration_status" {
  description = "Git integration configuration status"
  value = var.enable_git_integration ? {
    dev  = "Connected to ${var.git_repository}:main"
    test = "Connected to ${var.git_repository}:test"
    prod = "Connected to ${var.git_repository}:production"
  } : {
    dev  = "Not configured"
    test = "Not configured"
    prod = "Not configured"
  }
}
