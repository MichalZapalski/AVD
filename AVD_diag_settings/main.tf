data "azurerm_log_analytics_workspace" "loganalytics" {

  resource_group_name = var.lg_rg_name
  name                = var.lg_wrkspc_name
  #provider            = azurerm.la-provider

}

resource "azurerm_monitor_diagnostic_setting" "wrkspc_diag_settings" {
  name                       = "AVD_diagset"
  target_resource_id         = var.workspaceId
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.loganalytics.id

  log {
    category = "Feed"
    enabled  = true
  }
  log {
    category = "Error"
    enabled  = true
  }
  log {
    category = "Checkpoint"
    enabled  = true
  }
  log {
    category = "Management"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "hpool_diag_settings" {
  name                       = "AVD_diagset"
  target_resource_id         = var.hpoolid
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.loganalytics.id

  log {
    category = "Connection"
    enabled  = true
  }
  log {
    category = "Error"
    enabled  = true
  }
  log {
    category = "Checkpoint"
    enabled  = true
  }
  log {
    category = "Management"
    enabled  = true
  }
  log {
    category = "HostRegistration"
    enabled  = true
  }
  log {
    category = "AgentHealthStatus"
    enabled  = true
  }
  log {
    category = "NetworkData"
    enabled  = true
  }
  log {
    category = "SessionHostManagement"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "dag_diag_settings" {
  name                       = "AVD_diagset"
  target_resource_id         = var.appgrpid
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.loganalytics.id


  log {
    category = "Error"
    enabled  = true
  }
  log {
    category = "Checkpoint"
    enabled  = true
  }
  log {
    category = "Management"
    enabled  = true
  }
}