/*
terraform {
  backend "azurerm" {
    subscription_id      = "id of the subscription"
    resource_group_name  = "resource group name"
    storage_account_name = "storage account name"
    container_name       = "tfbackend"
    key                  = "tfstate file key"
    #use_oidc              = true
  }
}
*/
terraform {
  backend "azurerm" {
    subscription_id      = "id of subscription"
    resource_group_name  = "name of the resource group"
    storage_account_name = "name of the storage account name"
    container_name       = "tfbackend"
    key                  = "avd_deployment.tfstate"
    #use_oidc              = true
  }
}
