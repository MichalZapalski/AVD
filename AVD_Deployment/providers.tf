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
  subscription_id = "5ddf68c5-74a1-4a71-9092-0040ff11204e"
  #use_oidc = true
  skip_provider_registration = true
}
provider "azurerm" {
  features {}
  subscription_id            = "6bb0017a-46b6-494b-b79e-1881466cf7c9"
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
  subscription_id = "f46c3ccd-e389-4887-a964-baa05ec5b242"
  #use_oidc = true
  skip_provider_registration = true
}