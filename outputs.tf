output "datalake_id" {
  value = azurerm_storage_account.datalake.id
}

output "function_app_orchestrate_id" {
  value = azurerm_linux_function_app.orchestrate.id
}

output "key_vault_id" {
  value = azurerm_key_vault.key_vault_core.id
}