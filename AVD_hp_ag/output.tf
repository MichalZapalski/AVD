output "appgrnm" {
  value = azurerm_virtual_desktop_application_group.stl_cap_appgrp.name
}
output "hpnm" {
  value = azurerm_virtual_desktop_host_pool.stl_cap_hstpl.name
}
output "appgrid" {
  value = azurerm_virtual_desktop_application_group.stl_cap_appgrp.id
}
output "hpoolid" {
  value = azurerm_virtual_desktop_host_pool.stl_cap_hstpl.id
  
}