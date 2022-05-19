resource "azurerm_virtual_network" "myvnet" {
  name = var.vnet_name
  location            = var.deploy_location
  resource_group_name = var.rg_name
    address_space = ["10.0.0.0/16"]
    subnet {
    name           = var.subnet_name
    address_prefix = "10.0.1.0/24"
  }
}