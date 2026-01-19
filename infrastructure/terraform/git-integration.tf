# git-integration.tf - Workspace Git Configuration

# Development workspace - main branch
resource "fabric_workspace_git" "dev" {
  count = var.enable_git_integration ? 1 : 0
  
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
  count = var.enable_git_integration ? 1 : 0
  
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
  
  depends_on = [fabric_workspace_git.dev]
}

# Production workspace - production branch
resource "fabric_workspace_git" "prod" {
  count = var.enable_git_integration ? 1 : 0
  
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
  
  depends_on = [fabric_workspace_git.test]
}
