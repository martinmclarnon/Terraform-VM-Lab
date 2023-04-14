#
# Create virtual network.
#

resource "azurerm_virtual_network" "vnet_berlin" {
  name                = "vnet-berlin-${local.timestamp_sanitized}"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.rg-berlin.location
  resource_group_name = azurerm_resource_group.rg-berlin.name 
  tags                = local.common_tags
  depends_on          = [azurerm_resource_group.rg-berlin]
}

#
# Create SubNet.
#

resource "azurerm_subnet" "subnet_berlin" {
  name                 = "subnet-berlin-${local.timestamp_sanitized}"
  resource_group_name  = azurerm_resource_group.rg-berlin.name
  virtual_network_name = azurerm_virtual_network.vnet_berlin.name
  address_prefixes     = ["172.16.1.0/24"]
  depends_on           = [azurerm_virtual_network.vnet_berlin]
}