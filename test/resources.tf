# Create the resource group.
resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.project_name}-${local.environment}-${local.location}"
  location = local.location

  tags = merge({
    Environment = local.environment
    Product     = local.project_name
  }, local.tags)
}

resource "azurerm_storage_account" "storage" {
  name                = "stor${local.environment}${local.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  network_rules {
    default_action             = "Allow"
  }
  
  tags = merge({
    Environment    = local.environment
    Product        = local.project_name
  }, local.tags)
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.project_name}-${local.environment}"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_subnet" "internal" {
  name                 = "snet-${local.project_name}-${local.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "nic-${local.project_name}-${local.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "vm-${local.project_name}-${local.environment}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"
  #vm_size               = "Standard_H8"
  
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = merge({
    Environment    = local.environment
    Product        = local.project_name
  }, local.tags)
}