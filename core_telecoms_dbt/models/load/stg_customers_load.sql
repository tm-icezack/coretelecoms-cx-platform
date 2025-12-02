{{ config(
    materialized = 'incremental',
    unique_key   = 'customer_id'
) }}

SELECT
    *
FROM @RAW_PARQUET_STAGE/raw/customers/
    (FILE_FORMAT => 'RAW.PARQUET_FORMAT')

{% if is_incremental() %}

-- Only load rows with request_ids not already loaded
WHERE customer_id NOT IN (
    SELECT customer_id FROM {{ this }}
)

{% endif %}



 