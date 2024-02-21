/*
terraform {
  backend "azurerm" {
    subscription_id      = "5ddf68c5-74a1-4a71-9092-0040ff11204e"
    resource_group_name  = "rg-05896-d-004"
    storage_account_name = "sa05896d001"
    container_name       = "tfbackend"
    key                  = "avd_deployment.tfstate"
    #use_oidc              = true
  }
}
*/
terraform {
  backend "azurerm" {
    subscription_id      = "f46c3ccd-e389-4887-a964-baa05ec5b242"
    resource_group_name  = "rg-avd-infra"
    storage_account_name = "avdstoragewesteurope"
    container_name       = "tfbackend"
    key                  = "avd_deployment.tfstate"
    #use_oidc              = true
  }
}