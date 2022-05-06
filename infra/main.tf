resource "azurerm_resource_group" "main" {
  name     = "bees-sbx-mongodb"
  location = "eastus2"
  tags = {
    ResponsibleTeam = "Database & Storage"
  }
  lifecycle {
    ignore_changes = [
      tags["Creator"]
    ]
  }
}

module "mongodb-node-01" {
    source = "./ubuntu-server"
    resource_group_name = azurerm_resource_group.main.name
    server_name = "mongodb-node-01"
    location = "eastus2"
}

module "mongodb-node-02" {
    source = "./ubuntu-server"
    resource_group_name = azurerm_resource_group.main.name
    server_name = "mongodb-node-02"
    location = "eastus2"
}

module "mongodb-node-03" {
    source = "./ubuntu-server"
    resource_group_name = azurerm_resource_group.main.name
    server_name = "mongodb-node-03"
    location = "centralus"
}