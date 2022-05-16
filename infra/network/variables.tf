variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network."
}

variable "name" {
  type        = string
  description = "The name of the virtual network."
}

variable "location" {
  type        = string
  description = "The Azure Region in which the virtual network should be created."
}

variable "responsible_team" {
  type        = string
  description = "The team responsible for the resource group."
}
