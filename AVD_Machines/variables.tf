variable "rg_name" {}
variable "deploy_location" {}
variable "rdsh_count" {
  description = "Number of AVD machines to deploy"
}
variable "prefix" {}
variable "vm_size" {}
variable "tags_name" {
  type        = map(any)
}
variable "existingVnetName" {}
variable "existingWVDWorkspaceName" {}
variable "existingWVDHostPoolName" {}
variable "existingWVDAppGroupName" {}
variable "drainmode" {}
variable "createWorkspaceAppGroupAsso" {}
variable "existingSubnetName" {}
variable "SubscriptionId" {}
variable "kv_name" {}
variable "lg_wrkspc_name" {}
variable "lg_rg_name" {}
variable "vnetRg" {}
variable "kvRg" {}