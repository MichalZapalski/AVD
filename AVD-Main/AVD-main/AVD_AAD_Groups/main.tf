data "azuread_client_config" "current" {}


resource "azuread_group" "AVD_Admin" {
  display_name     = "AVD Admin"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  provider = azuread.ad_ten

}

resource "azuread_group" "AVD_User" {
  display_name     = "AVD User"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  provider = azuread.ad_ten
}