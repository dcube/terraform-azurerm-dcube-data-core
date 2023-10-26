variable "environment" {
  type = string
  description = "Environment trigram used for resource names. For example, dev, uat, tst, ppd, prd, ..."
}

variable "customer_code" {
  type = string
  description = "Customer code used for the resource names. 3 letters maximum is recommended"
}

variable "region_code" {
  type = string
  description = "Region code used for resource group names, for example weu for West Europe. 3 letters maximum is recommended"
}

#####################
# Resource names
#####################

variable "resource_group_name" {
  type = string
  default = "rg-data-core-${var.environment}-${var.region_code}-01"
}

variable "log_analytics_name" {
  type = string
  default = "log-${var.customer_code}-logs-${var.environment}-01"
}

variable "log_analytics_name_rg" {
  type = string
  default = "rg-infra-logs-${var.environment}-${var.region_code}-01"
}

variable "storage_diagnostics_name" {
  type = string
  default = "st${var.customer_code}datacore${var.environment}02"
}

variable "application_insight_name" {
  type = string
  default = "appi-${var.customer_code}-data-core-${var.environment}-01"
}

variable "data_factory_name" {
  type = string
  default = "adf-${var.customer_code}-data-core-${var.environment}-01"
}

variable "datalake_name" {
  type = string
  default = "st${var.customer_code}datacore${var.environment}01"
}

variable "key_vault_name" {
  type = string
  default = "kv-${var.customer_code}-data-core-${var.environment}-01"
}

variable "storage_function_app" {
  type = string
  default = "st${var.customer_code}datacore${var.environment}03"
}

variable "service_plan_name" {
  type = string
  default = "asp-${var.customer_code}-data-core-${var.environment}-01"
}

variable "orchestrate_function_name" {
  type = string
  default = "func-${var.customer_code}-data-core-${var.environment}-01"
}

#####################
# Identity
#####################

variable "current_object_id" {
  type = string
  default = data.azurerm_client_config.current.object_id
  description = "Current object id to assign roles"
}

#####################
# Storage
#####################

variable "storage_redundancy" {
  type = string
  description = "Redundancy for the storage accounts. For example, LRS, GRS, ..."
}

variable "storage_monitoring_retention" {
  type = number
  description = "Number of days for the log retention in the storage account"
}