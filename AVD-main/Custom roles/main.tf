data "azurerm_subscription" "primary" {
}

resource "azurerm_role_definition" "avd_custom_role" {
  name        = "start vm on connect"
  scope       = data.azurerm_subscription.primary.id
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = [""]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id, # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}