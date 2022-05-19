resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  location            = var.deploy_location
  resource_group_name = var.rg_name

  name                     = var.hp_name
  friendly_name            = var.hp_fr_name
  validate_environment     = false
  start_vm_on_connect      = true
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  description              = var.hp_descript
  type                     = "Personal"
  maximum_sessions_allowed = 1
  load_balancer_type       = "DepthFirst"
  personal_desktop_assignment_type = "Automatic"
}


resource "azurerm_virtual_desktop_application_group" "desktopapp" {
  name                = var.appgr_name
  location            = var.deploy_location
  resource_group_name = var.rg_name

  type          = var.appgr_type
  host_pool_id  = azurerm_virtual_desktop_host_pool.hostpool.id
  friendly_name = var.appgr_fr_name
  description   = var.appgr_descript
  default_desktop_display_name = var.appgr_disp_name
}


resource "azurerm_virtual_desktop_workspace_application_group_association" "workspaceremoteapp" {
  workspace_id         = var.workspace_id
  application_group_id = azurerm_virtual_desktop_application_group.desktopapp.id
}