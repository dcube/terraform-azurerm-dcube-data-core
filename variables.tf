variable "environment" {
  type        = string
  description = "Environment trigram used for resource names. For example, dev, uat, tst, ppd, prd, ..."
}

variable "customer_code" {
  type        = string
  description = "Customer code used for the resource names. 3 letters maximum is recommended"
}

variable "region_code" {
  type        = string
  description = "Region code used for resource group names, for example weu for West Europe. 3 letters maximum is recommended"
}

#####################
# Resource names
#####################

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Resource group where to create Data Core resources. Optional, default is 'rg-data-core-$${var.environment}-$${var.region_code}-01'"
}

variable "log_analytics_name" {
  type        = string
  default     = ""
  description = "Log analytics workspace name. Optional, default is 'log-$${var.customer_code}-logs-$${var.environment}-01'"
}

variable "log_analytics_name_rg" {
  type        = string
  default     = ""
  description = "Resource of the Log analytics workspace. Optional, if create_log_analytics_workspace=true then default value is the same than resource_group_name else default is 'rg-infra-logs-$${var.environment}-$${var.region_code}-01'"
}

variable "storage_diagnostics_name" {
  type        = string
  default     = ""
  description = "Name of the storage account used to store diagnostics. Optional, default is 'st$${var.customer_code}datacore$${var.environment}02'"
}

variable "application_insight_name" {
  type        = string
  default     = ""
  description = "Name of the application insight used by the function app. Optional, default is 'appi-$${var.customer_code}-data-core-$${var.environment}-01'"
}

variable "data_factory_name" {
  type        = string
  default     = ""
  description = "Name of the Data Factory. Optional, default is 'adf-$${var.customer_code}-data-core-$${var.environment}-01'"
}

variable "datalake_name" {
  type        = string
  default     = ""
  description = "Name of the storage account used as data lake. Optional, default is 'st$${var.customer_code}datacore$${var.environment}01'"
}

variable "key_vault_name" {
  type        = string
  default     = ""
  description = "Name of the key vault. Optional, default is 'kv-$${var.customer_code}-data-core-$${var.environment}-01'"
}

variable "storage_function_app" {
  type        = string
  default     = ""
  description = "Name of the storage account used by the function app. Optional, default is 'st$${var.customer_code}datacore$${var.environment}03'"
}

variable "service_plan_name" {
  type        = string
  default     = ""
  description = "Name of the plan used by the function app. Optional, default is 'asp-$${var.customer_code}-data-core-$${var.environment}-01'"
}

variable "orchestrate_function_name" {
  type        = string
  default     = ""
  description = "Name of the function used as orchestrator. Optional, default is 'func-$${var.customer_code}-data-core-$${var.environment}-01'"
}

#####################
# Identity
#####################

variable "current_object_id" {
  type        = string
  default     = ""
  description = "Current object id to assign roles. Optional, default value is data.azurerm_client_config.current.object_id"
}

#####################
# Storage
#####################

variable "storage_redundancy" {
  type        = string
  description = "Redundancy for the storage accounts. For example, LRS, GRS, ..."
}

variable "storage_monitoring_retention" {
  type        = number
  description = "Number of days for the log retention in the storage account"
}

#####################
# Snowflake
#####################
variable "snowflake_app_name" {
  type        = string
  default     = ""
  description = "Name of the SPN used by snowflake to connect to the datalake"
}

#####################
# Monitoring
#####################
variable "create_log_analytics_workspace" {
  type        = bool
  default     = false
  description = "True to create Log Analytics Workspace. False to use an existing one. Optional, default is false"
}

variable "log_analytics_retention" {
  type        = number
  default     = 90
  description = "umber of days for the log retention in the Log Analytics Workspace if variable create_log_analytics_workspace is true"
}