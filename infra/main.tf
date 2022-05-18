locals {
  resource_group_name = "mongodb-${var.cluster_name}"
  responsible_team    = "Database & Storage"
}

module "resource-group" {
  source           = "./resource-group"
  name             = local.resource_group_name
  location         = var.location
  responsible_team = local.responsible_team
}

module "network" {
  source              = "./network"
  name                = "${var.cluster_name}-network"
  resource_group_name = local.resource_group_name
  location            = var.location
  responsible_team    = local.responsible_team

  depends_on = [
    module.resource-group
  ]
}

module "mongodb-node" {
  count               = var.node_count
  source              = "./virtual-machine"
  resource_group_name = local.resource_group_name
  location            = var.location
  vm_size             = var.vm_size
  subnet_id           = module.network.subnet_id
  name                = "${var.cluster_name}-${count.index}"
  ssh_ip_access_list  = var.ssh_ip_access_list
  responsible_team    = local.responsible_team

  depends_on = [
    module.resource-group,
    module.network
  ]
}