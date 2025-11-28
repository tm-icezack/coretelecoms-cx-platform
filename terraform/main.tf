#############################################
# TERRAFORM BACKEND (Store TF State in S3)
#############################################

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
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-north-1"
}

#############################################
# S3 DATA LAKE - RAW BUCKET
#############################################

resource "aws_s3_bucket" "raw_data_bucket" {
  bucket = "coretelecoms-raw-data-lake-isaac"

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

#############################################
# S3 DATA LAKE — STAGING BUCKET
#############################################

resource "aws_s3_bucket" "staging_data_bucket" {
  bucket = "coretelecoms-staging-data-lake-isaac"

  tags = {
    Name = "CoreTelecoms Staging Data Lake"
  }
}

resource "aws_s3_bucket_versioning" "staging_versioning" {
  bucket = aws_s3_bucket.staging_data_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "staging_encryption" {
  bucket = aws_s3_bucket.staging_data_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#############################################
# PARAMETER STORE — SECURE DB CREDENTIALS
#############################################

# use input variables so passwords do NOT stay in the codebase

resource "aws_ssm_parameter" "postgres_credentials" {
  name        = "/customer_complaints/web_form_db_url"
  description = "Postgres connection string for Website Complaint Forms DB"
  type        = "SecureString"
  value       = var.postgres_db_url

  tags = {
    Project = "CoreTelecomsCX"
  }
}

