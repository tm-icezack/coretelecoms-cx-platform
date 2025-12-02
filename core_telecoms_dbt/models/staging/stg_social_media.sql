{{ config(materialized='view') }}

SELECT
    -- Keys and Identifiers: Use VALUE:"key" for mixed-case extraction
    VALUE:complaint_id::STRING AS complaint_key,
    VALUE:"customeR iD"::STRING AS customer_key,
    CAST(VALUE:"agent ID"::STRING AS VARCHAR) AS agent_key,

    -- Attributes
    VALUE:"COMPLAINT_catego ry"::STRING AS complaint_category,
    VALUE:resolutionstatus::STRING AS resolution_status,
    VALUE:media_channel::STRING AS platform_type,

   -- Timestamps
    CAST(NULLIF(VALUE:request_date::STRING, '') AS TIMESTAMP) AS request_timestamp,
    CAST(NULLIF(VALUE:resolution_date::STRING, '') AS TIMESTAMP) AS resolution_timestamp,

    -- Dates and Metadata (This is likely line 22)
    CAST(VALUE:MediaComplaintGenerationDate::STRING AS DATE) AS dbt_load_date,
    METADATA$FILENAME AS source_file_path
FROM RAW.SOCIAL_MEDIA_EXT