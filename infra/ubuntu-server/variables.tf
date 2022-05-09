variable "resource_group_name" {
  description = "The name of the resource group in which to create your virtual machine."
}

variable private_ip_address {
  description = "The private IP address to asign to the virtual machine"
}

variable subnet_id {
  description = "The subnet ID within the virtual machines will be created"
}

variable "server_name" {
  description = "The name of your server."
}

variable "location" {
  description = "The Azure Region in which your virtual machine should be created."
}
