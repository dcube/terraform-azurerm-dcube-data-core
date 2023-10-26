# data_core_terraform_module
Terraform module for "Core" in the dcube data architecture

# Prerequesite

## resources

These resources must exist:
- A Core resource group in which core resources will be created. Default value: rg-data-core-${var.environment}-${var.region_code}-01
- A resource group where a Log Analytics Workspace exist. Default value: rg-infra-logs-${var.environment}-${var.region_code}-01
- A Log Analytics Workspace. Default Log Analytics Workspace name: log-${var.customer_code}-logs-${var.environment}-01

## provider registration

These providers must be registered before running Terraform:
- microsoft.insights
- Microsoft.Web
- Microsoft.DataLakeStore
- Microsoft.KeyVault
- Microsoft.OperationalInsights
- Microsoft.DataFactory
- Microsoft.App
- Microsoft.Consumption
- Microsoft.Storage