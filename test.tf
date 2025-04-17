resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = "testrg"
  virtual_network_name = "testvnet"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = "testlocation"
  resource_group_name = "testrg"

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = "testlocation"
  resource_group_name = "testrg"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "subnetid"
    private_ip_address_allocation = "Dynamic"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = "testrg"
  location            = "testlocation"
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

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
}

resource "azurerm_storage_account" "example" {
  name                     = "storageaccountname"
  resource_group_name      = "resource_group_name"
  location                 = "location"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}