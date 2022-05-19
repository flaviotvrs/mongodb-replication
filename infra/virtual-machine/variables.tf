variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual machine."
}

variable "name" {
  type        = string
  description = "The name of the virtual machine."
}

variable "location" {
  type        = string
  description = "The Azure Region in which the virtual machine should be created."
}

variable "vm_size" {
  type        = string
  description = "The size of the virtual machine."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet in which the virtual machine should be created."
}

variable "ssh_ip_access_list" {
  type        = list(string)
  default     = []
  description = "The list of IP addresses to allow SSH access to the virtual machine."
}

variable "responsible_team" {
  type        = string
  description = "The team responsible for the resource group."
}