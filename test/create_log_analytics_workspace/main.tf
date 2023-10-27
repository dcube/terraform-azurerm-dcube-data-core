module "test2" {
  source = "../.."

  resource_group_name            = "rg-pocdata-domain-dev-01"
  create_log_analytics_workspace = true
  log_analytics_retention        = 30

  environment                  = "dev"
  customer_code                = "abc"
  region_code                  = "weu"
  storage_redundancy           = "LRS"
  storage_monitoring_retention = 30
}