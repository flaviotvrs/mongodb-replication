resource "azurerm_resource_group" "main" {
  name     = var.name
  location = var.location
  tags = {
    ResponsibleTeam = var.responsible_team
  }
}
