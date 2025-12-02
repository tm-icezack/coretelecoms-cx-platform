{{ config(
    materialized = 'incremental',
    unique_key   = 'call ID'
) }}

SELECT
    *
FROM @RAW_PARQUET_STAGE/raw/call_logs/
    (FILE_FORMAT => 'RAW.PARQUET_FORMAT')

{% if is_incremental() %}

-- Only load rows with request_ids not already loaded
WHERE "call ID" NOT IN (
    SELECT "call ID" FROM {{ this }}
)

{% endif %}



 