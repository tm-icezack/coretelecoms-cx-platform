# infra/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "coretelecoms-terraform-state-backend-cde-isaac" 
    key            = "platform/state/coretelecoms.tfstate"
    region         = "eu-north-1" 
    # REMOVE THIS LINE: dynamodb_table = "coretelecoms-tf-lock" 
    encrypt        = true
  }
}

# (Provider block remains the same)
provider "aws" {
  region = "eu-north-1"
}
# Data Lake S3 Buckets
# 1. RAW Data Bucket (for storing raw CSV, JSON, Parquet)
resource "aws_s3_bucket" "raw_data_bucket" {
  bucket = "coretelecoms-raw-data-lake-isaac" # <--- CHOOSE A UNIQUE NAME
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name = "CoreTelecoms Raw Data Lake"
  }
}

# 2. STAGING Data Bucket (for storing cleaned/intermediate Parquet)
resource "aws_s3_bucket" "staging_data_bucket" {
  bucket = "coretelecoms-staging-data-lake-isaac" # <--- CHOOSE A UNIQUE NAME
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name = "CoreTelecoms Staging Data Lake"
  }
}

# SSM Parameter for secure Postgres credentials
resource "aws_ssm_parameter" "postgres_credentials" {
  name        = "/customer_complaints/web_form_db_url"
  description = "Postgres connection string for Website Complaint Forms DB"
  type        = "SecureString"  
  # --- START OF REQUIRED UPDATE ---
  value       = "postgres://postgres.zrhqaykelfqavlbggufd:xzkM3JcIznixmlDX@aws-1-eu-west-1.pooler.supabase.com:6543/postgres" 
  # --- END OF REQUIRED UPDATE ---
  tags = {
    Project = "CoreTelecomsCX"
  }
}