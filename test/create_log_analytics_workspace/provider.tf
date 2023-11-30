#  Terraform backend
terraform {
  required_version = ">=1.3.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.78.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.45.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  storage_use_azuread        = "true"
  features {}
}