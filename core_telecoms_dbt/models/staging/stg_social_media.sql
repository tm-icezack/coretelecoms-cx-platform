-- models/staging/stg_social_media.sql (Complete, Robust Version)

{{ config(materialized='view') }}

SELECT
    complaint_id AS complaint_key,
    "customeR iD" AS customer_key,
    CAST("agent ID" AS VARCHAR) AS agent_key,

    "COMPLAINT_catego ry" AS complaint_category,
    resolutionstatus AS resolution_status,
    media_channel AS platform_type,

    -- Timestamp Fixes: Use NULLIF to convert empty strings ("") to NULL before casting
    CAST(NULLIF(request_date, '') AS TIMESTAMP) AS request_timestamp,
    CAST(NULLIF(resolution_date, '') AS TIMESTAMP) AS resolution_timestamp,

    CAST(MediaComplaintGenerationDate AS DATE) AS dbt_load_date,
    filename AS source_file_path -- Alias for auditing

FROM read_parquet(
    's3://coretelecoms-raw-data-lake-isaac/raw/social_media/*.parquet'
)