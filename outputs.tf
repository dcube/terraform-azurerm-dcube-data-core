output "datalake_id" {
  value       = azurerm_storage_account.datalake.id
  description = "Id of the storage account created for datalake"
}

output "function_app_orchestrate_id" {
  value       = azurerm_linux_function_app.orchestrate.id
  description = "Id of the function app created for orchestration"
}

output "key_vault_id" {
  value       = azurerm_key_vault.key_vault_core.id
  description = "Id of the key vault"
}

output "resource_group_name" {
  value       = data.azurerm_resource_group.this.name
  description = "Name of the resource group where resources are created"
}