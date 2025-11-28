{{ config(materialized='view') }}


SELECT
    customer_id AS customer_key,
    name AS full_name,
    Gender AS gender,
    CAST("DATE of biRTH" AS DATE) AS birth_date,
    CAST(signup_date AS DATE) AS signup_date,
    email,
    address AS full_address,
    filename AS source_file_path

FROM read_parquet(
    's3://coretelecoms-raw-data-lake-isaac/raw/customers/*.parquet'
)
