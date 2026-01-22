# capacity.tf - Fabric Capacity

# Data source for existing resource group (only when creating capacity)
data "azurerm_resource_group" "fabric" {
  count = var.create_capacity ? 1 : 0
  name  = var.resource_group_name
}

# Fabric Capacity (F-SKU)
resource "azurerm_fabric_capacity" "main" {
  count = var.create_capacity ? 1 : 0
  
  name                = "fc${replace(var.project_name, "_", "")}${var.environment}"
  resource_group_name = data.azurerm_resource_group.fabric[0].name
  location            = var.location
  
  sku {
    name = var.capacity_sku
    tier = "Fabric"
  }
  
  administration_members = concat(
    [data.azuread_client_config.current.object_id],
    var.workspace_admins
  )
  
  tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}
