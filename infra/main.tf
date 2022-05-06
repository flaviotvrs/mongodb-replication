resource "azurerm_resource_group" "main" {
  name     = "bees-sbx-mongodb"
  location = "eastus2"
  tags = {
    ResponsibleTeam = "Database & Storage"
  }
}

module "mongodb-node-01" {
    source = "./ubuntu-server"
    resource_group_name = azurerm_resource_group.main.name
    server_name = "mongodb-node-01"
    location = "eastus2"
}