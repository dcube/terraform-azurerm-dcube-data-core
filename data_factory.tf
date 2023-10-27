# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory
resource "azurerm_data_factory" "this" {
  name                = local.resource_names.data_factory_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  identity {
    type = "SystemAssigned"
  }

  tags = merge(data.azurerm_resource_group.this.tags, { Role = "ADF resource for the Data architecture" })

  lifecycle {
    ignore_changes = [vsts_configuration, global_parameter] #ne pas changer cette config mise en place par le déploiement ADF
  }
}

# Add Storage Blob Data Contributor rôle to Data Factory over the Datalake
resource "azurerm_role_assignment" "adf_to_datalake_data_contributor" {
  scope                = azurerm_storage_account.datalake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.this.identity[0].principal_id
}

# #############################################################################
# Diagnostic/log settings
# #############################################################################
# Diagnostic on datafactory
resource "azurerm_monitor_diagnostic_setting" "diagnostics_adf" {
  name                           = "diag-${azurerm_data_factory.this.name}-01"
  target_resource_id             = azurerm_data_factory.this.id
  storage_account_id             = azurerm_storage_account.storage_diagnostics.id
  log_analytics_workspace_id     = var.create_log_analytics_workspace ? azurerm_log_analytics_workspace.log[0].id : data.azurerm_log_analytics_workspace.log[0].id
  log_analytics_destination_type = "AzureDiagnostics"

  enabled_log {
    category = "ActivityRuns"
  }

  enabled_log {
    category = "PipelineRuns"
  }

  enabled_log {
    category = "TriggerRuns"
  }

  metric {
    category = "AllMetrics"
  }
}