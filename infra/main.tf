resource "azurerm_resource_group" "main" {
  name     = "mongodb-repl"
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

resource "azurerm_virtual_network" "main" {
  name                = "replset-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "mongodb"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

module "mongodb-node-01" {
    source = "./ubuntu-server"
    resource_group_name = azurerm_resource_group.main.name
    private_ip_address = "10.0.2.4"
    subnet_id = azurerm_subnet.main.id
    server_name = "node-01"
    location = "eastus2"
}

module "mongodb-node-02" {
    source = "./ubuntu-server"
    resource_group_name = azurerm_resource_group.main.name
    private_ip_address = "10.0.2.5"
    subnet_id = azurerm_subnet.main.id
    server_name = "node-02"
    location = "eastus2"
}

# module "mongodb-node-03" {
#     source = "./ubuntu-server"
#     resource_group_name = azurerm_resource_group.main.name
#     private_ip_address = "10.0.2.6"
#     subnet_id = azurerm_subnet.main.id
#     server_name = "node-03"
#     location = "centralus"
# }