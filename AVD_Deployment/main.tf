module "avdworkspace" {
  source               = "../AVD_workspace"
  wrkspc_name          = "TeamCenter_Dev"
  wrkspc_rg_name       = "rg-stella-test"
  wrkspc_description   = "Dev environment"
  wrkspc_friendly_name = "Dev environment"
  deploy_location      = "west europe"
  tags_name = {
    "Environment"    = "Dev"
    "appid"          = "05896"
    "application_id" = "avd"
  }
}

module "ag_hp" {
  source          = "../AVD_hp_ag"
  rg_name         = "rg-stella-test"
  deploy_location = "west europe"
  hp_descript     = "hostpul"
  hp_name         = "myavdhostpool"
  hp_fr_name      = "anyhostpool"
  hp_type         = "Pooled"
  rdp_prop        = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1"
  lb_type         = "DepthFirst"
  appgr_descript  = "aplikajszongroup"
  appgr_disp_name = "Default desktop"
  appgr_fr_name   = "anyappgr"
  appgr_name      = "avdappgroup"
  appgr_type      = "Desktop"
  workspace_id    = module.avdworkspace.workspaceid
  tags_name = {
    "Environment"    = "Dev"
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
  rg_name                     = "rg-stella-test"
  deploy_location             = "west europe"
  rdsh_count                  = "1"
  prefix                      = "VDItest"
  vm_size                     = "Standard_D2s_v4"
  existingVnetName            = "vnet-avd"
  existingSubnetName          = "snet-avd-pier"
  existingWVDAppGroupName     = module.ag_hp.appgrnm
  existingWVDHostPoolName     = module.ag_hp.hpnm
  existingWVDWorkspaceName    = module.avdworkspace.workspacenm
  drainmode                   = "no"
  createWorkspaceAppGroupAsso = "No"
  SubscriptionId              = "f46c3ccd-e389-4887-a964-baa05ec5b242"
  kv_name                     = "kv-avd-plumeria"
  lg_wrkspc_name              = "la-avd"
  lg_rg_name                  = "rg-la-avd"
  vnetRg                      = "rg-avd-infra"
  kvRg                        = "rg-avd-infra"
  depends_on = [
    module.ag_hp
  ]
  tags_name = {
    "Environment"    = "Dev"
    "appid"          = "05896"
    "application_id" = "avd"
  }
}