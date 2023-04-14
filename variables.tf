# Set values for Locals and Variables.

#
# Locals
#


locals {
  timestamp           = timestamp()
  timestamp_sanitized = "${replace("${local.timestamp}", "/[-| |T|Z|:]/", "")}"
  
  # Common tags to be assigned to all resources
  common_tags = { 
    Environment  = var.environment 
    Department   = "[YOUR_VARIABLE_NAME]" 
  }

  resource_group_location_berlin_without_spaces = "${replace("${var.resource_group_location_berlin}","/[ ]/", "")}"
  resource_group_location_newyork_without_spaces = "${replace("${var.resource_group_location_newyork}","/[ ]/", "")}"
  vm_domain_name_label                   = "lab-${local.timestamp_sanitized}"
  resource_group_berlin                  = "rg-${var.resource_group_workload}-${var.environment}-${local.resource_group_location_berlin_without_spaces}-${local.timestamp_sanitized}-${var.resource_group_name_creator}"
  resource_group_newyork                 = "rg-${var.resource_group_workload}-${var.environment}-${local.resource_group_location_newyork_without_spaces}-${local.timestamp_sanitized}-${var.resource_group_name_creator}"

}

#
# Variables
#

variable "subscription_id" {
  default      = "[YOUR_VARIABLE_NAME]"
  description  = "subscription_id for Azure Subscription: [SOME_SUBSCRIPTION]"
}

variable "environment" {
  default       = "[YOUR_VARIABLE_NAME]"
  description   = "Group Environment."
}

variable "resource_group_workload" {
  default       = "[YOUR_VARIABLE_NAME]"
  description   = "rg workload name - hint at what its for."
}

variable "resource_group_name_creator" {
  default       = "[YOUR_VARIABLE_NAME]"
  description   = "Name of contributor creating the resource group - to identify creator."
}

variable "resource_group_location_berlin" {
  default       = "Germany West Central"
  description   = "Location of the resource group."
}

variable "resource_group_location_newyork" {
  default       = "East US"
  description   = "Location of the resource group."
}

variable "network_security_group_security_rule_source_address_prefixes" {
  type          = list(string)
  default       = ["[YOUR_VARIABLE_NAME]"]
  description   = "Source addresses requiring access to VMs"
}