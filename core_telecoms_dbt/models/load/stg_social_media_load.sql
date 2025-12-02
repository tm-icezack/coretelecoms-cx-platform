{{ config(
    materialized = 'incremental',
    unique_key   = 'complaint_id'
) }}

SELECT
    *
FROM @RAW_PARQUET_STAGE/raw/social_media/
    (FILE_FORMAT => 'RAW.PARQUET_FORMAT')

{% if is_incremental() %}

-- Only load rows with request_ids not already loaded
WHERE complaint_id NOT IN (
    SELECT complaint_id FROM {{ this }}
)

{% endif %}
