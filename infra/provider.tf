terraform {
  required_version = "1.1.7"

  backend "local" {}

  required_providers {
    azurerm = {
      # source  = "hashicorp/azurerm"
      version = "=3.5.0"
    }
  }
}

provider "azurerm" {
  features {}
}