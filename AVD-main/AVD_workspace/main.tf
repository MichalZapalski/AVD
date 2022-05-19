resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = var.workspace_name
  location            = var.deploy_location
  resource_group_name = data.azurerm_resource_group.rg.name

  friendly_name = var.fr_name
  description   = var.descript
}

data "azurerm_resource_group" "rg" {
  name = var.rg_name

  
}