module "example1" {
  source = "value"

  environment                  = "dev"
  customer_code                = "abc"
  region_code                  = "weu"
  storage_redundancy           = "LRS"
  storage_monitoring_retention = 30
  snowflake_app_name           = "azertysnowflake"
}