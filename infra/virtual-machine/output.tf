output "private_ip" {
  value = azurerm_network_interface.main.private_ip_address
  depends_on = [
    azurerm_network_interface.main
  ]
}

output "public_ip" {
  value      = azurerm_public_ip.main.ip_address
  depends_on = []
}
