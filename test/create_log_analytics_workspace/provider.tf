#  Terraform backend
terraform {
  required_version = ">=1.3.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.39.1"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.32.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  storage_use_azuread        = "true"
  features {}
}