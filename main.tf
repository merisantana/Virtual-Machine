data "azurerm_resource_group" "RG" {
  name = var.resurce_group_name
}


########################################################################
  
  
resource "azurerm_virtual_network" "vnet" {
  name                = var.namevnet
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.RG.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.namesubnet
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.RG.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = var.namenic
  location            = var.location
  resource_group_name = data.azurerm_resource_group.RG.name

  ip_configuration {
    name                          = var.namesubnet
    subnet_id                     = azurerm_subnet.vnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
  
 resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.namevm
  resource_group_name = data.azurerm_resource_group.RG.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "usuario"
  admin_password      = "P4$$w0rdP4$$W0rd"
  network_interface_ids = [
    azurerm_network_interface.vm.id,
  ]
}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
}

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
}
