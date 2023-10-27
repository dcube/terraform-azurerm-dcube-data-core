module "test1" {
  source = "../.."

  resource_group_name          = "rg-pocdata-domain-dev-01"
  log_analytics_name_rg        = "rg-pocdata-domain-dev-01"
  log_analytics_name           = "log-test-nico-01"
  environment                  = "dev"
  customer_code                = "abc"
  region_code                  = "weu"
  storage_redundancy           = "LRS"
  storage_monitoring_retention = 30
}