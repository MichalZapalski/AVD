resource "azurerm_virtual_desktop_application_group" "desktopapp" {
  name                = var.appgr_name
  location            = var.deploy_location
  resource_group_name = var.rg_name

  type          = var.appgr_type
  host_pool_id  = var.hostpool_id
  friendly_name = var.appgr_fr_name
  description   = var.appgr_descript
  default_desktop_display_name = var.appgr_disp_name
}

