locals {
  current_object_id = length(var.current_object_id) > 0 ? var.current_object_id : data.azurerm_client_config.current.object_id
  resource_names = {
    resource_group_name = length(var.resource_group_name) > 0 ? var.resource_group_name : "rg-data-core-${var.environment}-${var.region_code}-01"
    monitoring = {
      log_analytics_name       = length(var.log_analytics_name) > 0 ? var.log_analytics_name : "log-${var.customer_code}-logs-${var.environment}-01"
      # if we create the log analytics workspace then default RG is local.resource_names.resource_group_name
      log_analytics_name_rg    = length(var.log_analytics_name_rg) > 0 ? var.log_analytics_name_rg : (var.create_log_analytics_workspace ? (length(var.resource_group_name) > 0 ? var.resource_group_name : "rg-data-core-${var.environment}-${var.region_code}-01") : "rg-infra-logs-${var.environment}-${var.region_code}-01")
      storage_diagnostics_name = length(var.storage_diagnostics_name) > 0 ? var.storage_diagnostics_name : "st${var.customer_code}datacore${var.environment}02"
      application_insight_name = length(var.application_insight_name) > 0 ? var.application_insight_name : "appi-${var.customer_code}-data-core-${var.environment}-01"
    }
    datalake_name  = length(var.datalake_name) > 0 ? var.datalake_name : "st${var.customer_code}datacore${var.environment}01"
    key_vault_name = length(var.key_vault_name) > 0 ? var.key_vault_name : "kv-${var.customer_code}-data-core-${var.environment}-01"
    function_app = {
      storage_function_app      = length(var.storage_function_app) > 0 ? var.storage_function_app : "st${var.customer_code}datacore${var.environment}03"
      service_plan_name         = length(var.service_plan_name) > 0 ? var.service_plan_name : "asp-${var.customer_code}-data-core-${var.environment}-01"
      orchestrate_function_name = length(var.orchestrate_function_name) > 0 ? var.orchestrate_function_name : "func-${var.customer_code}-data-core-${var.environment}-01"
    }
    data_factory_name = length(var.data_factory_name) > 0 ? var.data_factory_name : "adf-${var.customer_code}-data-core-${var.environment}-01"
  }
}