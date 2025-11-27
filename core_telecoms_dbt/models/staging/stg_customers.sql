-- models/staging/stg_customers.sql

SELECT
    customer_id AS customer_key,
    name AS full_name,
    Gender AS gender,
    CAST("DATE of biRTH" AS DATE) AS birth_date,
    CAST(signup_date AS DATE) AS signup_date,
    email,
    address AS full_address

FROM read_parquet('s3://coretelecoms-raw-data-lake-isaac/raw/customers/*.parquet')