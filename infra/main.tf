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

resource "azurerm_virtual_network" "eastus2" {
  name                = "eastus2-replset-network"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "eastus2" {
  name                 = "mongodb"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.eastus2.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_virtual_network" "centralus" {
  name                = "centralus-replset-network"
  address_space       = ["10.0.0.0/16"]
  location            = "centralus"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "centralus" {
  name                 = "mongodb"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.centralus.name
  address_prefixes     = ["10.0.2.0/24"]
}

module "mongodb-node-01" {
    source = "./ubuntu-server"
    resource_group_name = azurerm_resource_group.main.name
    private_ip_address = "10.0.2.4"
    subnet_id = azurerm_subnet.eastus2.id
    server_name = "node-01"
    location = "eastus2"
}

module "mongodb-node-02" {
    source = "./ubuntu-server"
    resource_group_name = azurerm_resource_group.main.name
    private_ip_address = "10.0.2.5"
    subnet_id = azurerm_subnet.eastus2.id
    server_name = "node-02"
    location = "eastus2"
}

module "mongodb-node-03" {
    source = "./ubuntu-server"
    resource_group_name = azurerm_resource_group.main.name
    private_ip_address = "10.0.2.6"
    subnet_id = azurerm_subnet.centralus.id
    server_name = "node-03"
    location = "centralus"
}