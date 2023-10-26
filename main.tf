data "azurerm_client_config" "current" {}

# Reference to the project ressource group
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "log" {
  name                = var.log_analytics_name
  resource_group_name = var.log_analytics_name_rg
}