{{ config(
    materialized = 'incremental',
    unique_key   = 'request_id'
) }}

SELECT
    *
FROM @RAW_PARQUET_STAGE/raw/web_forms/
    (FILE_FORMAT => 'RAW.PARQUET_FORMAT')

{% if is_incremental() %}

-- Only load rows with request_ids not already loaded
WHERE request_id NOT IN (
    SELECT request_id FROM {{ this }}
)

{% endif %}
