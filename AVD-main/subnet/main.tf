data "azurerm_virtual_network" "myvnet" {
  name = var.vnet_name
  resource_group_name = var.rg_name

}




resource "azurerm_virtual_network" "myvnet" {
  name = data.azurerm_virtual_network.myvnet.name
  location            = var.deploy_location
  resource_group_name = var.rg_name
    address_space = data.azurerm_virtual_network.myvnet.address_space
    subnet {
    name           = var.subnet_name
    address_prefix = "10.0.1.0/24"
  }
}