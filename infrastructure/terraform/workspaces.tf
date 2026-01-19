# workspaces.tf - Fabric Workspaces

locals {
  capacity_id = var.create_capacity ? azurerm_fabric_capacity.main[0].id : var.existing_capacity_id
}

# Development Workspace
resource "fabric_workspace" "dev" {
  display_name = "${var.project_name}_dev"
  description  = "Development workspace for ${var.project_name} - managed by Terraform"
  
  capacity_id = local.capacity_id
}

# Test Workspace
resource "fabric_workspace" "test" {
  display_name = "${var.project_name}_test"
  description  = "Test workspace for ${var.project_name} - managed by Terraform"
  
  capacity_id = local.capacity_id
}

# Production Workspace
resource "fabric_workspace" "prod" {
  display_name = "${var.project_name}_prod"
  description  = "Production workspace for ${var.project_name} - managed by Terraform"
  
  capacity_id = local.capacity_id
}
