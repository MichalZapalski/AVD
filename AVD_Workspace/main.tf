resource "azurerm_virtual_desktop_workspace" "stl_cap_wrspc" {
  name                = var.wrkspc_name
  resource_group_name = var.wrkspc_rg_name
  location            = var.deploy_location
  tags                = var.tags_name
  description         = var.wrkspc_description
  friendly_name       = var.wrkspc_friendly_name
  timeouts {}
  lifecycle {}

}