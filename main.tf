data "azurerm_client_config" "current" {}

# Reference to the project ressource group
data "azurerm_resource_group" "this" {
  name = local.resource_names.resource_group_name
}

data "azurerm_log_analytics_workspace" "log" {
  name                = local.resource_names.log_analytics_name
  resource_group_name = local.resource_names.log_analytics_name_rg
}