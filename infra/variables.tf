variable "cluster_name" {
  type        = string
  description = "The name of the cluster."
}

variable "location" {
  type        = string
  description = "The location in which the replica set will be created."
}

variable "vm_size" {
  type        = string
  description = "The size of the virtual machine."
}

variable "node_count" {
  type        = number
  default     = 3
  description = "The number of nodes in the cluster."
}

variable "ssh_ip_access_list" {
  type        = list(string)
  default     = []
  description = "The list of IP addresses to allow SSH access to the virtual machine."
}
