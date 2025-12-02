##################################################
# TERRAFORM CONFIG & BACKEND
##################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 2.1"
    }
  }

  backend "s3" {
    bucket  = "coretelecoms-terraform-state-backend-cde-isaac"
    key     = "platform/state/coretelecoms.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}

##################################################
# AWS PROVIDER
##################################################
provider "aws" {
  region = "eu-north-1"
}

##################################################
# SNOWFLAKE PROVIDER
##################################################
provider "snowflake" {
  organization_name = "GGKLVWF"
  account_name      = "HS76764"
  user              = var.snowflake_user
  password          = var.snowflake_password
  role              = var.snowflake_role
}

##################################################
# AWS S3 RAW BUCKET
##################################################
resource "aws_s3_bucket" "raw_data_bucket" {
  bucket = var.s3_raw_bucket

  tags = {
    Name = "CoreTelecoms Raw Data Lake"
  }
}

resource "aws_s3_bucket_versioning" "raw_versioning" {
  bucket = aws_s3_bucket.raw_data_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "raw_encryption" {
  bucket = aws_s3_bucket.raw_data_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##################################################
# AWS SSM PARAMETERS (OPTIONAL)
##################################################
resource "aws_ssm_parameter" "postgres_credentials" {
  name        = "/customer_complaints/web_form_db_url"
  description = "Postgres connection string"
  type        = "SecureString"
  value       = var.postgres_db_url

  tags = {
    Project = "CoreTelecomsCX"
  }
}

##################################################
# SNOWFLAKE WAREHOUSE
##################################################
resource "snowflake_warehouse" "coretelecoms_warehouse" {
  name                = "CORETELECOMS_WH"
  warehouse_size      = "XSMALL"
  auto_suspend        = 300
  auto_resume         = true
  max_cluster_count   = 1
  initially_suspended = true

  comment = "Warehouse for CoreTelecoms Analytics"
}

##################################################
# SNOWFLAKE DATABASE & SCHEMA
##################################################
resource "snowflake_database" "coretelecoms_db" {
  name    = "CORETELECOMS_DB"
  comment = "Database for CoreTelecoms Analytics"
}

resource "snowflake_schema" "raw_schema" {
  name     = "RAW"
  database = snowflake_database.coretelecoms_db.name
  comment  = "Raw data schema"
}

##################################################
# NOTE:
# File format and stage already exist in Snowflake:
#   - File format: CORETELECOMS_DB.RAW.PARQUET_FORMAT
#   - Stage: CORETELECOMS_DB.RAW.RAW_PARQUET_STAGE
# Terraform will NOT manage them.
##################################################
