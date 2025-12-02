{{ config(materialized='view') }}

SELECT
    -- Keys and Identifiers: Use VALUE:"key" for mixed-case extraction
    VALUE:request_id::STRING AS request_key,
    VALUE:"customeR iD"::STRING AS customer_key,
    CAST(VALUE:"agent ID"::STRING AS VARCHAR) AS agent_key,

    -- Attributes
    VALUE:"COMPLAINT_catego ry"::STRING AS complaint_category,
    VALUE:resolutionstatus::STRING AS resolution_status,

    -- Timestamps
    CAST(NULLIF(VALUE:request_date::STRING, '') AS TIMESTAMP) AS request_timestamp,
    CAST(NULLIF(VALUE:resolution_date::STRING, '') AS TIMESTAMP) AS resolution_timestamp, -- FIXED: Added ) before the comma

    -- Dates and Metadata
    CAST(VALUE:webFormGenerationDate::STRING AS DATE) AS dbt_load_date,
    METADATA$FILENAME AS source_file_path -- Use Snowflake's metadata column

FROM RAW.WEB_FORMS_EXT