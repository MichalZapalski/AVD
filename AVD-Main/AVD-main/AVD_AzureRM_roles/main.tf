data "azurerm_subscription" "primary" {
}

data "azuread_service_principal" "sth" {
  object_id = "ab296599-97e9-4ea7-866c-9f4939a97b27"
  #application_id = "9cdead84-a844-4324-93f2-b2e6bb768d07"
}

resource "azurerm_role_definition" "avd_custom_role" {
  name        = "start vm on connect"
  scope       = data.azurerm_subscription.primary.id
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = ["Microsoft.Compute/virtualMachines/start/action",
"Microsoft.Compute/virtualMachines/read",
"Microsoft.Compute/virtualMachines/instanceView/read"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id, # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}


resource "azurerm_role_assignment" "AVD_role_assignment" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "start vm on connect"
  principal_id         = data.azuread_service_principal.sth.object_id
  depends_on = [
    azurerm_role_definition.avd_custom_role
  ]
}




resource "azurerm_role_definition" "avd_custom_role2" {
  name        = "deallocate vm on logoff"
  scope       = data.azurerm_subscription.primary.id
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = ["Microsoft.Compute/virtualMachines/deallocate/action"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id, # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}
