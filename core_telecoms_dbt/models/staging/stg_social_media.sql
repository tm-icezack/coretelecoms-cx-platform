-- models/staging/stg_social_media.sql

SELECT
    -- Keys and Identifiers
    complaint_id AS complaint_key,
    "customeR iD" AS customer_key,
    CAST("agent ID" AS VARCHAR) AS agent_key,

    -- Attributes
    "COMPLAINT_catego ry" AS complaint_category,
    resolutionstatus AS resolution_status,
    media_channel AS platform_type,

    -- Timestamps
    CAST(request_date AS TIMESTAMP) AS request_timestamp,
    CAST(resolution_date AS TIMESTAMP) AS resolution_timestamp,

    -- Metadata
    CAST(MediaComplaintGenerationDate AS DATE) AS dbt_load_date

FROM read_parquet('s3://coretelecoms-raw-data-lake-isaac/raw/social_media/*.parquet')