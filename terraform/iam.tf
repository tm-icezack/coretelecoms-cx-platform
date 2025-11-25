/*
# coretelecorms/terraform/iam.tf (COMMENTED OUT FOR LACK OF PERMISSIONS)

## 1. IAM Role Definition
resource "aws_iam_role" "data_lake_etl_role" {
  name               = "coretelecoms-data-lake-etl-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com" 
        }
      },
    ]
  })
  tags = {
    Project = "CoreTelecorms"
  }
}

## 2. IAM Policy Definition
resource "aws_iam_policy" "data_lake_access_policy" {
  # ... (Policy definition for S3 access remains here) ...
}

## 3. Attach Policy to Role
resource "aws_iam_role_policy_attachment" "etl_role_policy_attachment" {
  role       = aws_iam_role.data_lake_etl_role.name
  policy_arn = aws_iam_policy.data_lake_access_policy.arn
}

*/ 
# Leave this file commented out until you have permission to create IAM resources.