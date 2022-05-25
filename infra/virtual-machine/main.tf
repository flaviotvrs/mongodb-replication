resource "azurerm_public_ip" "main" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
  tags = {
    ResponsibleTeam = var.responsible_team
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {

    for_each = { for i, v in var.ssh_ip_access_list : i => v }

    content {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "SSH_${replace(security_rule.value, ".", "_")}"
      priority                   = 200 + security_rule.key
      protocol                   = "Tcp"
      source_address_prefix      = security_rule.value
      source_port_range          = "*"
      destination_port_range     = "22"
      destination_address_prefix = azurerm_network_interface.main.private_ip_address
    }

  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "MongoDB_Inbound"
    priority                   = 101
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "27017"
    destination_address_prefix = azurerm_network_interface.main.private_ip_address
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = "dbadmin"
  admin_password                  = "P4ssw0rd;"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
