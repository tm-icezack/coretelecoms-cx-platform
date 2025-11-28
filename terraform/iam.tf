/*
# infra/iam.tf (Corrected and ready for uncommenting when permissions are granted)

## 1. Redshift IAM Role (for S3 COPY access)
resource "aws_iam_role" "redshift_s3_access_role" {
  name = "redshift-s3-access-role-coretelecoms"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      },
    ]
  })
}

## 2. IAM Policy Definition (Grants read access to S3 Data Lakes)
resource "aws_iam_policy" "redshift_s3_read_policy" {
  name        = "redshift-s3-read-policy-coretelecoms"
  description = "Grants read access to the raw and staging data lakes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ]
        Effect   = "Allow"
        Resource = [
          # Add both bucket ARNs here
          aws_s3_bucket.raw_data_bucket.arn,
          "${aws_s3_bucket.raw_data_bucket.arn}/*",
          aws_s3_bucket.staging_data_bucket.arn,
          "${aws_s3_bucket.staging_data_bucket.arn}/*",
        ]
      },
    ]
  })
}

## 3. Attach Policy to Role
resource "aws_iam_role_policy_attachment" "redshift_s3_read_attachment" {
  role       = aws_iam_role.redshift_s3_access_role.name
  policy_arn = aws_iam_policy.redshift_s3_read_policy.arn
}
*/