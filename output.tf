output "berlin_resource_group_name" {
  value = azurerm_resource_group.rg-berlin.name
}

output "berlin_vm_tls_private_key_minion" {
  value     = tls_private_key.ssh_key_berlin_minion.private_key_pem
  sensitive = true
}

output "berlin_vm_tls_private_key_node" {
  value     = tls_private_key.ssh_key_berlin_node.private_key_pem
  sensitive = true
}


output "newyork_resource_group_name" {
  value = azurerm_resource_group.rg-newyork.name
}

output "newyork_vm_tls_private_key_minion" {
  value     = tls_private_key.ssh_key_newyork_minion.private_key_pem
  sensitive = true
}

output "newyork_vm_tls_private_key_node" {
  value     = tls_private_key.ssh_key_newyork_node.private_key_pem
  sensitive = true
}