#  Terraform backend
terraform {
  required_version = ">=1.3.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.39.1"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = "true"
  storage_use_azuread        = "true"
  features {}
}