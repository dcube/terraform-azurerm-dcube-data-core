# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault
resource "azurerm_key_vault" "key_vault_core" {
  name                        = local.resource_names.key_vault_name
  location                    = data.azurerm_resource_group.this.location
  resource_group_name         = data.azurerm_resource_group.this.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  tags = merge(data.azurerm_resource_group.this.tags, { Role = "Key vault to store data crentials. Used by ADF and the function app" })
}

# #############################################################################
# Secrets
# #############################################################################

resource "azurerm_key_vault_secret" "function_orchestrator_key" {
  name         = "orchestrator-key"
  value        = data.azurerm_function_app_host_keys.orchestrate.default_function_key
  key_vault_id = azurerm_key_vault.key_vault_core.id

  depends_on = [
    azurerm_key_vault_access_policy.keyvault_policies_azure_devops
  ]
}

# #############################################################################
# Access policies
# #############################################################################

# Add Policies to Azure Devops Service Principal
resource "azurerm_key_vault_access_policy" "keyvault_policies_azure_devops" {
  key_vault_id = azurerm_key_vault.key_vault_core.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = local.current_object_id

  secret_permissions = [
    "Get",
    "List",
    "Backup",
    "Delete",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]
}

resource "azurerm_key_vault_access_policy" "keyvault_policies_adf" {
  key_vault_id = azurerm_key_vault.key_vault_core.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_data_factory.this.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_access_policy" "keyvault_policies_function_app" {
  key_vault_id = azurerm_key_vault.key_vault_core.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_function_app.orchestrate.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

# #############################################################################
# Diagnostic/log settings
# #############################################################################
# Diagnostic on the keyvault
resource "azurerm_monitor_diagnostic_setting" "diagnostic_key_vault" {
  name                       = "diag-${azurerm_key_vault.key_vault_core.name}-01"
  target_resource_id         = azurerm_key_vault.key_vault_core.id
  storage_account_id         = azurerm_storage_account.storage_diagnostics.id
  log_analytics_workspace_id = var.create_log_analytics_workspace ? azurerm_log_analytics_workspace.log[0].id : data.azurerm_log_analytics_workspace.log[0].id
  log_analytics_destination_type = "AzureDiagnostics"

  metric {
    category = "AllMetrics"
  }
}