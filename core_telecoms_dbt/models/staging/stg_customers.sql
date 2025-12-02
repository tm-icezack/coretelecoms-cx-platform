{{ config(materialized='view') }}

SELECT
    -- Use VARIANT parsing (VALUE:"key") and cast to specific types
    VALUE:customer_id::STRING AS customer_key,
    VALUE:name::STRING AS full_name,
    VALUE:Gender::STRING AS gender,
    CAST(VALUE:"DATE of biRTH"::STRING AS DATE) AS birth_date,
    CAST(VALUE:signup_date::STRING AS DATE) AS signup_date,
    VALUE:email::STRING AS email,
    VALUE:address::STRING AS full_address,

    -- Use METADATA$FILENAME for file path in Snowflake External Tables
    METADATA$FILENAME AS source_file_path

FROM RAW.CUSTOMERS_EXT