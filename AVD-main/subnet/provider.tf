terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.5.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = ">2.20.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "7474e679-4ce3-4d84-afd4-61e9e1b650bf"
  features {
    
  }
}

#provider "azurerm" {
  # Configuration options
#  features {   
#  }
#  subscription_id = "7474e679-4ce3-4d84-afd4-61e9e1b650bf"
#  alias = "B"
#}

provider "azuread" {
  # Configuration options
  alias = "ad_ten"
}