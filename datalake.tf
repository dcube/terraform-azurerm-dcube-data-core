# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account
# Create Storage Account for Datalake
resource "azurerm_storage_account" "datalake" {
  name                              = var.datalake_name
  resource_group_name               = data.azurerm_resource_group.this.name
  location                          = data.azurerm_resource_group.this.location
  account_tier                      = "Standard"
  account_replication_type          = var.storage_redundancy
  account_kind                      = "StorageV2"
  access_tier                       = "Hot"
  is_hns_enabled                    = "true"
  shared_access_key_enabled         = false
  infrastructure_encryption_enabled = true

  tags = merge(data.azurerm_resource_group.this.tags, { Role = "Datalake" })

}

resource "azurerm_storage_data_lake_gen2_filesystem" "datalake" {
  name               = "datalake"
  storage_account_id = azurerm_storage_account.datalake.id

  depends_on = [
    azurerm_role_assignment.datalake_iam_devops_owner
  ]
}

############################
### Assignment
############################

resource "azurerm_role_assignment" "datalake_iam_devops_owner" {
  scope                = azurerm_storage_account.datalake.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.current_object_id
}

resource "azurerm_role_assignment" "datalake_iam_snowflake_contributor" {
  scope                = azurerm_storage_account.datalake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_service_principal.snowflake.object_id
}

# #############################################################################
# Diagnostic/log settings
# #############################################################################
resource "azurerm_monitor_diagnostic_setting" "diagnostics_datalake" {
  name                       = "diag-${azurerm_storage_account.datalake.name}-01"
  target_resource_id         = azurerm_storage_account.datalake.id
  storage_account_id         = azurerm_storage_account.storage_diagnostics.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log.id

  metric {
    category = "Transaction"
  }

  metric {
    category = "Capacity"
    enabled  = false
  }
}