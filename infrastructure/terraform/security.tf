# security.tf - Workspace Security & Service Principals

# Get current authenticated user/service principal
data "azuread_client_config" "current" {}

# -----------------------------------------
# Workspace Admin Role Assignments
# -----------------------------------------
# NOTE: Workspace creators are automatically assigned as Admin.
# These resources are commented out to avoid "PrincipalAlreadyHasWorkspaceRolePermissions" errors.
# Uncomment if you need to add additional admins who are NOT the workspace creator.

# # Development workspace - current user as admin
# resource "fabric_workspace_role_assignment" "dev_admin" {
#   workspace_id = fabric_workspace.dev.id
#   principal = {
#     id   = data.azuread_client_config.current.object_id
#     type = "User"
#   }
#   role = "Admin"
# }

# # Test workspace - current user as admin
# resource "fabric_workspace_role_assignment" "test_admin" {
#   workspace_id = fabric_workspace.test.id
#   principal = {
#     id   = data.azuread_client_config.current.object_id
#     type = "User"
#   }
#   role = "Admin"
# }

# # Production workspace - current user as admin
# resource "fabric_workspace_role_assignment" "prod_admin" {
#   workspace_id = fabric_workspace.prod.id
#   principal = {
#     id   = data.azuread_client_config.current.object_id
#     type = "User"
#   }
#   role = "Admin"
# }

# -----------------------------------------
# CI/CD Service Principal
# -----------------------------------------

# Application registration for CI/CD pipeline
resource "azuread_application" "cicd" {
  display_name = "sp-${var.project_name}-cicd"
  
  owners = [data.azuread_client_config.current.object_id]
  
  required_resource_access {
    resource_app_id = "00000009-0000-0000-c000-000000000000" # Power BI Service
    
    resource_access {
      id   = "f3076109-ca66-412a-be10-d4ee1be95d47" # Tenant.Read.All
      type = "Scope"
    }
    resource_access {
      id   = "7f33e027-4039-419b-938e-2f8ca153e68e" # Workspace.ReadWrite.All
      type = "Scope"
    }
  }
}

# Service Principal from the application
resource "azuread_service_principal" "cicd" {
  client_id = azuread_application.cicd.client_id
  owners    = [data.azuread_client_config.current.object_id]
  
  feature_tags {
    enterprise = true
  }
}

# Client secret for the service principal
resource "azuread_service_principal_password" "cicd" {
  service_principal_id = azuread_service_principal.cicd.id
  display_name         = "CI/CD Pipeline Secret"
  end_date             = timeadd(timestamp(), "8760h") # 1 year from now

  lifecycle {
    ignore_changes = [end_date]
  }
}

# -----------------------------------------
# CI/CD Service Principal Workspace Access
# -----------------------------------------

# Grant CI/CD service principal Admin access to Development
resource "fabric_workspace_role_assignment" "cicd_dev" {
  workspace_id = fabric_workspace.dev.id
  principal = {
    id   = azuread_service_principal.cicd.object_id
    type = "ServicePrincipal"
  }
  role = "Admin"
}

# Grant CI/CD service principal Admin access to Test
resource "fabric_workspace_role_assignment" "cicd_test" {
  workspace_id = fabric_workspace.test.id
  principal = {
    id   = azuread_service_principal.cicd.object_id
    type = "ServicePrincipal"
  }
  role = "Admin"
}

# Grant CI/CD service principal Admin access to Production
resource "fabric_workspace_role_assignment" "cicd_prod" {
  workspace_id = fabric_workspace.prod.id
  principal = {
    id   = azuread_service_principal.cicd.object_id
    type = "ServicePrincipal"
  }
  role = "Admin"
}

# -----------------------------------------
# Additional Admin Assignments (optional)
# -----------------------------------------

# Dynamic admin assignments from variable
# Note: Assumes all additional admins are Users. For mixed types, use a map variable.
resource "fabric_workspace_role_assignment" "additional_dev_admins" {
  for_each = toset(var.workspace_admins)
  
  workspace_id = fabric_workspace.dev.id
  principal = {
    id   = each.value
    type = "User"
  }
  role = "Admin"
}

resource "fabric_workspace_role_assignment" "additional_test_admins" {
  for_each = toset(var.workspace_admins)
  
  workspace_id = fabric_workspace.test.id
  principal = {
    id   = each.value
    type = "User"
  }
  role = "Admin"
}

resource "fabric_workspace_role_assignment" "additional_prod_admins" {
  for_each = toset(var.workspace_admins)
  
  workspace_id = fabric_workspace.prod.id
  principal = {
    id   = each.value
    type = "User"
  }
  role = "Admin"
}
