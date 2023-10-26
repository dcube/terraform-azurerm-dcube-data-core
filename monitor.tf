# Create Storage Account for diagnostics
resource "azurerm_storage_account" "storage_diagnostics" {
  name                              = var.storage_diagnostics_name
  resource_group_name               = data.azurerm_resource_group.this.name
  location                          = data.azurerm_resource_group.this.location
  account_tier                      = "Standard"
  account_replication_type          = var.storage_redundancy
  account_kind                      = "StorageV2"
  access_tier                       = "Hot"
  is_hns_enabled                    = "false"
  infrastructure_encryption_enabled = true

  tags = merge(data.azurerm_resource_group.this.tags, { Role = "Storage containing diagnostics" })
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy
# Rule to clean diagnistic logs
resource "azurerm_storage_management_policy" "diagnostics_blob_retention" {
  storage_account_id = azurerm_storage_account.storage_diagnostics.id

  rule {
    name    = "blobToDelete"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = var.storage_monitoring_retention
      }
    }
  }
}

# Create blob container
resource "azurerm_storage_container" "storage_container_diagnostics" {
  name                  = "diag"
  storage_account_name  = azurerm_storage_account.storage_diagnostics.name
  container_access_type = "private"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights
resource "azurerm_application_insights" "this" {
  name                = var.application_insight_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  workspace_id        = data.azurerm_log_analytics_workspace.log.id
  application_type    = "other"

  tags = merge(data.azurerm_resource_group.this.tags, { Role = "Log management for the function app" })
}