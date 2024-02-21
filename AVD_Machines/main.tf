# Global Data
data "azurerm_key_vault" "stl_keyvault" {
  name                = var.kv_name
  resource_group_name = var.kvRg
}
data "azurerm_key_vault_secret" "localadmin" {
  name         = "AVDLocalUserUsername"
  key_vault_id = data.azurerm_key_vault.stl_keyvault.id
}
data "azurerm_key_vault_secret" "localadmin_password" {
  name         = "AVDLocalUserPassword"
  key_vault_id = data.azurerm_key_vault.stl_keyvault.id
}
data "azurerm_key_vault_secret" "domainadmin" {
  name         = "DomainJoinAccountUsername"
  key_vault_id = data.azurerm_key_vault.stl_keyvault.id
}
data "azurerm_key_vault_secret" "domainadmin_password" {
  name         = "DomainJoinAccountPassword"
  key_vault_id = data.azurerm_key_vault.stl_keyvault.id
}
data "azurerm_key_vault_secret" "lg_workspace_primary_key" {
  name         = "laprimarykey"
  key_vault_id = data.azurerm_key_vault.stl_keyvault.id
}
data "azurerm_key_vault_secret" "tenant_id" {
  name         = "tenantid"
  key_vault_id = data.azurerm_key_vault.stl_keyvault.id
}
data "azurerm_key_vault_secret" "app_id" {
  name         = "avdspn-clientid"
  key_vault_id = data.azurerm_key_vault.stl_keyvault.id
}
data "azurerm_key_vault_secret" "spn_key" {
  name         = "avdspn-secret"
  key_vault_id = data.azurerm_key_vault.stl_keyvault.id
}
data "azurerm_key_vault_secret" "ou" {
  name         = "ou"
  key_vault_id = data.azurerm_key_vault.stl_keyvault.id
}
data "azurerm_key_vault_secret" "domainname" {
  name         = "domainname"
  key_vault_id = data.azurerm_key_vault.stl_keyvault.id
}
data "azurerm_subnet" "subnet" {
  name                 = var.existingSubnetName
  virtual_network_name = var.existingVnetName
  resource_group_name  = var.vnetRg
}
data "azurerm_log_analytics_workspace" "loganalytics" {
  resource_group_name = var.lg_rg_name
  name                = var.lg_wrkspc_name
  #provider            = azurerm.la-provider
}
resource "azurerm_network_interface" "avd_vm_nic" {
  count                         = var.rdsh_count
  name                          = "${var.prefix}-${format("%03d", count.index + 1)}-nic"
  resource_group_name           = var.rg_name
  location                      = var.deploy_location
  enable_accelerated_networking = true
  tags                          = var.tags_name

  ip_configuration {
    name                          = "nic${count.index + 1}_config"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  timeouts {
    create = "2h"
    delete = "2h"
  }
}
resource "azurerm_windows_virtual_machine" "avd_vm" {
  count                      = var.rdsh_count
  admin_password             = data.azurerm_key_vault_secret.localadmin_password.value
  admin_username             = data.azurerm_key_vault_secret.localadmin.value
  allow_extension_operations = true
  enable_automatic_updates   = false
  encryption_at_host_enabled = false
  extensions_time_budget     = "PT1H30M"
  hotpatching_enabled        = false
  license_type               = "Windows_Client"
  location                   = var.deploy_location
  name                       = "${var.prefix}${format("%03d", count.index + 1)}"
  network_interface_ids      = ["${azurerm_network_interface.avd_vm_nic.*.id[count.index]}"]
  patch_mode                 = "Manual"
  priority                   = "Regular"
  provision_vm_agent         = true
  resource_group_name        = var.rg_name
  secure_boot_enabled        = false

  identity {
    type = "SystemAssigned"
  }

  size = var.vm_size

  #source_image_id = var.image_id

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-avd"
    version   = "latest"
  }

  tags         = var.tags_name
  vtpm_enabled = false

  os_disk {
    name                 = "${lower(var.prefix)}${format("%03d", count.index + 1)}_osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"

  }
  depends_on = [
    azurerm_network_interface.avd_vm_nic
  ]

  timeouts {
    create = "3h"
    delete = "2h"
  }


  lifecycle {
    ignore_changes = [
      source_image_reference,
    ]
  }
}

resource "azurerm_virtual_machine_extension" "monitor-DependencyAgent-agent" {

  count                      = var.rdsh_count
  name                       = "DependencyAgentWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.5"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  depends_on = [azurerm_windows_virtual_machine.avd_vm
  ]
  settings = <<SETTINGS
        {
          "workspaceId": "${data.azurerm_log_analytics_workspace.loganalytics.workspace_id}"
        }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${data.azurerm_key_vault_secret.lg_workspace_primary_key.value}"
        }
PROTECTED_SETTINGS

  tags = var.tags_name

  timeouts {
    create = "2h"
    delete = "2h"
  }

}

resource "azurerm_virtual_machine_extension" "monitor-agent" {
  count                      = var.rdsh_count
  name                       = "MicrosoftMonitoringAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  depends_on = [azurerm_windows_virtual_machine.avd_vm,
    azurerm_virtual_machine_extension.monitor-DependencyAgent-agent
  ]
  settings = <<SETTINGS
        {
          "workspaceId": "${data.azurerm_log_analytics_workspace.loganalytics.workspace_id}"
        }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${data.azurerm_key_vault_secret.lg_workspace_primary_key.value}"
        }
PROTECTED_SETTINGS

  tags = var.tags_name

  timeouts {
    create = "2h"
    delete = "2h"
  }


}

resource "azurerm_virtual_machine_extension" "avd_AMA" {
  count                      = var.rdsh_count
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  depends_on = [
    azurerm_virtual_machine_extension.monitor-DependencyAgent-agent,
  ]
  settings = <<SETTINGS
    {
          "workspaceId": "${data.azurerm_log_analytics_workspace.loganalytics.workspace_id}"
    }
SETTINGS

  protected_settings = <<PROTECTEDSETTINGS
    {
          "workspaceKey": "${data.azurerm_key_vault_secret.lg_workspace_primary_key.value}"
    }
PROTECTEDSETTINGS
  tags               = var.tags_name

  timeouts {
    create = "2h"
    delete = "2h"
  }

}

resource "azurerm_virtual_machine_extension" "avd_script" {
  count                      = var.rdsh_count
  name                       = "CustomScriptExtension"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true
  depends_on = [
    azurerm_windows_virtual_machine.avd_vm,
    azurerm_virtual_machine_extension.avd_AMA,
  ]
  settings = <<SETTINGS
    {
      "fileUris": [
      "https://avdstoragewesteurope.blob.core.windows.net/avdscript/Add-WVDHostToHostpoolSpringORG4T.ps1?sp=r&st=2023-03-13T15:29:51Z&se=2024-03-13T23:29:51Z&spr=https&sv=2021-12-02&sr=b&sig=ehRkhf39SPodcmQLXtOT%2FvR8%2FQYcPjWh9l7jGOjsyfI%3D"
      ]
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
"commandToExecute": "powershell.exe -executionpolicy Unrestricted -File \"./Add-WVDHostToHostpoolSpringORG4T.ps1\" ${var.existingWVDWorkspaceName} ${var.existingWVDHostPoolName} ${var.existingWVDAppGroupName} ${data.azurerm_key_vault_secret.app_id.value} ${data.azurerm_key_vault_secret.spn_key.value} ${data.azurerm_key_vault_secret.tenant_id.value} ${var.rg_name} ${var.SubscriptionId} ${var.drainmode} ${var.createWorkspaceAppGroupAsso} "
    }
  PROTECTED_SETTINGS


  tags = var.tags_name

  timeouts {
    create = "2h"
    delete = "2h"
  }

}


#Join_Domain
resource "azurerm_virtual_machine_extension" "domain_join" {
  count                      = var.rdsh_count
  name                       = "JsonADDomainExtension"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  tags                       = var.tags_name
  settings                   = <<SETTINGS
    {
      "Name": "${data.azurerm_key_vault_secret.domainname.value}",
      "OUPath": "${data.azurerm_key_vault_secret.ou.value}",
      "User": "${data.azurerm_key_vault_secret.domainadmin.value}@${data.azurerm_key_vault_secret.domainname.value}",
      "Restart": "true",
      "Options": "3"
    
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${data.azurerm_key_vault_secret.domainadmin_password.value}"
    }
PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [
    azurerm_virtual_machine_extension.monitor-DependencyAgent-agent,
    azurerm_virtual_machine_extension.avd_script
  ]

  timeouts {
    create = "2h"
    delete = "2h"
  }
}