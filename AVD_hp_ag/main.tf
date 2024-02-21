resource "azurerm_virtual_desktop_host_pool" "stl_cap_hstpl" {
  name                             = var.hp_name
  resource_group_name              = var.rg_name
  location                         = var.deploy_location
  tags                             = var.tags_name
  custom_rdp_properties            = var.rdp_prop
  load_balancer_type               = var.lb_type
  description                      = var.hp_descript
  friendly_name                    = var.hp_fr_name
  maximum_sessions_allowed         = 10
  preferred_app_group_type         = "Desktop"
  type                             = var.hp_type
  personal_desktop_assignment_type = "Automatic"
  start_vm_on_connect              = true
  lifecycle {
    ignore_changes = [
      personal_desktop_assignment_type,
    ]
  }
}

resource "azurerm_virtual_desktop_application_group" "stl_cap_appgrp" {
  name                         = var.appgr_name
  resource_group_name          = var.rg_name
  location                     = var.deploy_location
  tags                         = var.tags_name
  default_desktop_display_name = var.appgr_disp_name
  host_pool_id                 = azurerm_virtual_desktop_host_pool.stl_cap_hstpl.id
  description                  = var.appgr_descript
  friendly_name                = var.appgr_fr_name
  type                         = "Desktop"
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "stl_cap_app_wrkspc_asso" {
  application_group_id = azurerm_virtual_desktop_application_group.stl_cap_appgrp.id
  workspace_id         = var.workspace_id
}