output "subnet_id" {
  value = azurerm_subnet.main.id
  depends_on = [
    azurerm_subnet.main
  ]
}
