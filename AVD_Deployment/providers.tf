/*
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.5.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "subscription ID"
  #use_oidc = true
  skip_provider_registration = true
}
provider "azurerm" {
  features {}
  subscription_id            = "subscription ID"
  #use_oidc                   = true
  alias                      = "la-provider"
  skip_provider_registration = true
}
*/
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.5.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "subscription ID"
  #use_oidc = true
  skip_provider_registration = true
}
