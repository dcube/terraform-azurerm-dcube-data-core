# dcube/dcube-data-core/azurerm
Terraform module for "Data Core" in the dcube data architecture
https://registry.terraform.io/modules/dcube/dcube-data-core/azurerm/latest

# Prerequesites

## resources

These resources must exist:
- A storage account for terraform state
- A Core resource group in which core resources will be created. Default value: ***rg-data-core-{var.environment}-{var.region_code}-01***
- A SPN to run the CI/CD
- If you use Azure Devops: a Service Connection associated with the previous SPN
- If you use Gihub: put client ID et Client secret of the previous SPN in Environment variables

Log Analytics Workspace can either be created by terraform or be specified as a data source (if you want this resource to be used by other projects).
If you want Terraform to create a Log Analytics Workspace, assign variable ***create_log_analytics_workspace*** to true. Default is false
So, if ***create_log_analytics_workspace=false*** or is not specified:
- A Log Analytics Workspace must exist. Default Log Analytics Workspace name: ***log-{var.customer_code}-logs-{var.environment}-01***
- Resource group for this Log Analytics Workspace has a default value: ***rg-infra-logs-{var.environment}-{var.region_code}-01***

## provider registration

These providers must be registered on the target subscription before running Terraform:
- microsoft.insights
- Microsoft.Web
- Microsoft.DataLakeStore
- Microsoft.KeyVault
- Microsoft.OperationalInsights
- Microsoft.DataFactory
- Microsoft.App
- Microsoft.Consumption
- Microsoft.Storage

## Permissions

To run this Terraform project you need these permissions (the SPN in the CI/CD):
- SPN must be ***Storage Account Key Operator Service Role*** on terraform storage account
- SPN must be ***Owner*** of its resource group

# Usage

This module creates resources with Microsoft naming convention: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming.
But you can overwrite the resource naming by using your own naming.

## Basic usage

In this example, resources are created with the default reousrce names:
```HCL
module "dcube-data-core" {
  source  = "dcube/dcube-data-core/azurerm"
  version = "1.0.0"
  
  environment                  = "dev"
  customer_code                = "abc"
  region_code                  = "weu"
  storage_redundancy           = "LRS"
  storage_monitoring_retention = 30
  snowflake_app_name           = "azertysnowflake"
}
```

## Specific resource naming

In this example, we specify the name of the resource groups:
```HCL
module "dcube-data-core" {
  source  = "dcube/dcube-data-core/azurerm"
  version = "1.0.0"
  
  resource_group_name          = "data-core-rg"
  log_analytics_name_rg        = "logs-data-core-rg"

  environment                  = "dev"
  customer_code                = "abc"
  region_code                  = "weu"
  storage_redundancy           = "LRS"
  storage_monitoring_retention = 30
  snowflake_app_name           = "azertysnowflake"
}
```

## Create Log Analytics Workspace

As described in the [resources chapter](##resources), by default this module use an existing Log Analytics Workspace. 
Here is an example to create a new Log Analytics Workspace:
```HCL
module "dcube-data-core" {
  source  = "dcube/dcube-data-core/azurerm"
  version = "1.0.0"
  
  create_log_analytics_workspace = true
  log_analytics_retention        = 30
  
  environment                    = "dev"
  customer_code                  = "abc"
  region_code                    = "weu"
  storage_redundancy             = "LRS"
  storage_monitoring_retention   = 90
}
```