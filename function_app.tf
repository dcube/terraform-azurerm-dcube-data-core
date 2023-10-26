# Create Storage Account for fonction app
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "function_app_orchestrate" {
  name                              = local.resource_names.function_app.storage_function_app
  resource_group_name               = data.azurerm_resource_group.this.name
  location                          = data.azurerm_resource_group.this.location
  account_tier                      = "Standard"
  account_replication_type          = var.storage_redundancy
  account_kind                      = "StorageV2"
  access_tier                       = "Hot"
  infrastructure_encryption_enabled = true

  tags = merge(data.azurerm_resource_group.this.tags, { Role = "Storage used for the orchestration function app" })
}

resource "azurerm_service_plan" "orchestrate" {
  name                = local.resource_names.function_app.service_plan_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  os_type             = "Linux"
  sku_name            = "Y1"

  tags = merge(data.azurerm_resource_group.this.tags, { Role = "Service plan used for the orchestration function app" })
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app
resource "azurerm_linux_function_app" "orchestrate" {
  name                          = local.resource_names.function_app.orchestrate_function_name
  resource_group_name           = data.azurerm_resource_group.this.name
  location                      = data.azurerm_resource_group.this.location
  storage_account_name          = azurerm_storage_account.function_app_orchestrate.name
  service_plan_id               = azurerm_service_plan.orchestrate.id
  functions_extension_version   = "~4"
  storage_uses_managed_identity = true
  https_only                    = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    http2_enabled                          = true
    ftps_state                             = "Disabled"
    application_insights_key               = azurerm_application_insights.this.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.this.connection_string
    minimum_tls_version                    = 1.2

    application_stack {
      python_version = "3.9"
    }
  }

  tags = merge(data.azurerm_resource_group.this.tags, { Role = "Orchestrator for the data project" })

  lifecycle {
    ignore_changes = [
      app_settings,
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-instrumentation-key"],
    tags["hidden-link: /app-insights-resource-id"]]
  }
}

##################################################################################
# Role Assignments
##################################################################################
// https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-reader
// allows for blobServices/generateUserDelegationKey and blobs/read
resource "azurerm_role_assignment" "function_orchestrate_to_blob_contributor" {
  scope                = azurerm_storage_account.function_app_orchestrate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_function_app.orchestrate.identity[0].principal_id
}

// https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-account-key-operator-service-role
// allows for listkeys/action and regeneratekey/action
resource "azurerm_role_assignment" "function_orchestrate_to_storage_key_operator" {
  scope                = azurerm_storage_account.function_app_orchestrate.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azurerm_linux_function_app.orchestrate.identity[0].principal_id
}

// https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#reader-and-data-access
// allows for storageAccounts/read
resource "azurerm_role_assignment" "function_orchestrate_to_storage_reader_and_data_access" {
  scope                = azurerm_storage_account.function_app_orchestrate.id
  role_definition_name = "Reader and Data Access"
  principal_id         = azurerm_linux_function_app.orchestrate.identity[0].principal_id
}

# For durable function
resource "azurerm_role_assignment" "function_orchestrate_to_queue_contributor" {
  scope                = azurerm_storage_account.function_app_orchestrate.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_linux_function_app.orchestrate.identity[0].principal_id
}

# For durable function
resource "azurerm_role_assignment" "function_orchestrate_to_table_contributor" {
  scope                = azurerm_storage_account.function_app_orchestrate.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_linux_function_app.orchestrate.identity[0].principal_id
}

##################################################################################
# Function key
##################################################################################
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/function_app_host_keys
data "azurerm_function_app_host_keys" "orchestrate" {
  name                = azurerm_linux_function_app.orchestrate.name
  resource_group_name = data.azurerm_resource_group.this.name
}