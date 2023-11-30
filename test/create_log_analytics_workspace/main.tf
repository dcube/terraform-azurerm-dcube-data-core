module "test2" {
  source = "../.."

  create_log_analytics_workspace = true
  log_analytics_retention        = 30

  environment                  = "dev"
  customer_code                = "abc"
  region_code                  = "weu"
  storage_redundancy           = "LRS"
  storage_monitoring_retention = 30
}