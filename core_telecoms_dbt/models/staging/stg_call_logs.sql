{{ config(materialized='view') }}

SELECT
    -- Keys and Identifiers
    VALUE:"call ID"::STRING AS call_key,
    VALUE:"customeR iD"::STRING AS customer_key,
    CAST(VALUE:"agent ID"::STRING AS VARCHAR) AS agent_key,

    -- Attributes
    VALUE:"COMPLAINT_catego ry"::STRING AS complaint_category,
    VALUE:"resolutionstatus"::STRING AS resolution_status,

    -- Timestamps
    CAST(VALUE:call_start_time::STRING AS TIMESTAMP) AS call_timestamp,
    CAST(VALUE:call_end_time::STRING AS TIMESTAMP) AS call_end_timestamp,

    -- Metadata (tracking lineage)
    CAST(VALUE:callLogsGenerationDate::STRING AS DATE) AS dbt_load_date,
    METADATA$FILENAME AS source_file_path -- Note: filename is a metadata column

FROM RAW.CALL_LOGS_EXT