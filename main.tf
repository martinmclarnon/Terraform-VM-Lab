
#
# Create Resource Group - using naming convention defined by Microsoft [ResourceType]-[Workload/Application]-[Environment]-[AzureRegion]-[Instance] 
#

resource "azurerm_resource_group" "rg-berlin" {
  name     = local.resource_group_berlin
  location = var.resource_group_location_berlin
  tags     = local.common_tags
}

resource "azurerm_resource_group" "rg-newyork" {
  name     = local.resource_group_newyork
  location = var.resource_group_location_newyork
  tags     = local.common_tags
}