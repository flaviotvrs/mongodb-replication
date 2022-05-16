resource "azurerm_virtual_network" "main" {
  name                = var.name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    ResponsibleTeam = var.responsible_team
  }
}

resource "azurerm_subnet" "main" {
  name                 = "${var.name}-sub"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}
