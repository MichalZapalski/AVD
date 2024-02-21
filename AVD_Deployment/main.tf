module "avdworkspace" {
  source               = "../AVD_workspace"
  wrkspc_name          = "name of workspace"
  wrkspc_rg_name       = "workspace resource group name"
  wrkspc_description   = "workspace description"
  wrkspc_friendly_name = "workspace friendly name"
  deploy_location      = "west europe"
  tags_name = {
    "Environment"    = "environment "
    "appid"          = "app id"
    "application_id" = "avd"
  }
}

module "ag_hp" {
  source          = "../AVD_hp_ag"
  rg_name         = "resource group name"
  deploy_location = "west europe"
  hp_descript     = "host pool description"
  hp_name         = "host pool name"
  hp_fr_name      = "host pool friendly name"
  hp_type         = "Pooled"
  rdp_prop        = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1"
  lb_type         = "DepthFirst"
  appgr_descript  = "Application group description"
  appgr_disp_name = "Application group display name"
  appgr_fr_name   = "Application Group friendly name"
  appgr_name      = "Application Group Name"
  appgr_type      = "Desktop"
  workspace_id    = module.avdworkspace.workspaceid
  tags_name = {
    "Environment"    = "Name of the environment"
    "appid"          = "05896"
    "application_id" = "avd"
  }
  depends_on = [
    module.avdworkspace,
  ]
}

module "diag_sett" {
  source         = "../AVD_diag_settings"
  lg_rg_name     = "rg-la-avd"
  lg_wrkspc_name = "la-avd"
  workspaceId    = module.avdworkspace.workspaceid
  hpoolid        = module.ag_hp.hpoolid
  appgrpid       = module.ag_hp.appgrid

}

module "AVD_machines" {
  source                      = "../AVD_machines"
  rg_name                     = "resource group name"
  deploy_location             = "west europe"
  rdsh_count                  = "1"
  prefix                      = "name of virtual machine"
  vm_size                     = "Standard_D2s_v4"
  existingVnetName            = "vnet-avd"
  existingSubnetName          = "name of subnet"
  existingWVDAppGroupName     = module.ag_hp.appgrnm
  existingWVDHostPoolName     = module.ag_hp.hpnm
  existingWVDWorkspaceName    = module.avdworkspace.workspacenm
  drainmode                   = "no"
  createWorkspaceAppGroupAsso = "No"
  SubscriptionId              = "ID of the subscription"
  kv_name                     = "name of keyvault"
  lg_wrkspc_name              = "la-avd"
  lg_rg_name                  = "rg-la-avd"
  vnetRg                      = "rg-avd-infra"
  kvRg                        = "rg-avd-infra"
  depends_on = [
    module.ag_hp
  ]
  tags_name = {
    "Environment"    = "name of environment"
    "appid"          = "05896"
    "application_id" = "avd"
  }
}
