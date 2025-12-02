
variable "postgres_db_url" {
  type = string
}

variable "snowflake_account" {}
variable "snowflake_user" {}
variable "snowflake_password" {}
variable "snowflake_role" {
  default = "SYSADMIN"
}
variable "snowflake_region" {
  default = "EU-NORTH-1"
}


variable "aws_access_key" {
  type        = string
  description = "AWS Access Key for Snowflake stage"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key for Snowflake stage"
  sensitive   = true
}

variable "s3_raw_bucket" {
  type    = string
  default = "coretelecoms-raw-data-lake-isaac"
}
