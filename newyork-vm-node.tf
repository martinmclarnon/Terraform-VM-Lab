
#
# Create Public IP.
#

resource "azurerm_public_ip" "publicip_newyork_node" {
  name                = "pip-newyork-node-${local.timestamp_sanitized}"
  location            = azurerm_resource_group.rg-newyork.location
  resource_group_name = azurerm_resource_group.rg-newyork.name
  allocation_method   = "Dynamic"
  domain_name_label   = "newyork-node-vm-${local.timestamp_sanitized}"
}

#
# Create Network Security Group and rules
#
resource "azurerm_network_security_group" "nsg_newyork_node" {
  name                = "nsg-newyork-node-${local.timestamp_sanitized}"
  location            = azurerm_resource_group.rg-newyork.location
  resource_group_name = azurerm_resource_group.rg-newyork.name

  security_rule {
    name                       = "AllowSSHInBound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.network_security_group_security_rule_source_address_prefixes
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic_newyork_node" {
  name                = "nic-newyork-node-${local.timestamp_sanitized}"
  location            = azurerm_resource_group.rg-newyork.location
  resource_group_name = azurerm_resource_group.rg-newyork.name

  ip_configuration {
    name                          = "NicConfiguration"
    subnet_id                     = azurerm_subnet.subnet_newyork.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip_newyork_node.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg_association_newyork_node" {
  network_interface_id      = azurerm_network_interface.nic_newyork_node.id
  network_security_group_id = azurerm_network_security_group.nsg_newyork_node.id
}


# Create (and display) an SSH key
resource "tls_private_key" "ssh_key_newyork_node" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm_newyork_node" {
  name                  = "vm-newyork-node-${local.timestamp_sanitized}"
  location              = azurerm_resource_group.rg-newyork.location
  resource_group_name   = azurerm_resource_group.rg-newyork.name
  network_interface_ids = [azurerm_network_interface.nic_newyork_node.id]
  size                  = "Standard_D4s_v3"

  os_disk {
    name                 = "vm-newyork-node-${local.timestamp_sanitized}-dataDisk-0"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "vm-newyork-node-${local.timestamp_sanitized}"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh_key_newyork_node.public_key_openssh
  }
  
  depends_on           = [azurerm_network_interface.nic_newyork_node]
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown-schedule-newyork-node" {
  virtual_machine_id = azurerm_linux_virtual_machine.vm_newyork_node.id
  location           = azurerm_resource_group.rg-newyork.location
  enabled            = true

  daily_recurrence_time = "2100"
  timezone              = "UTC"


  notification_settings {
    enabled         = false
   
  }

  depends_on = [azurerm_linux_virtual_machine.vm_newyork_node]
 }