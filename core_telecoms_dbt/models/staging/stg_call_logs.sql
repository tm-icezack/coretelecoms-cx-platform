{{ config(materialized='view') }}



SELECT
    -- Keys and Identifiers
    "call ID" AS call_key,
    "customeR iD" AS customer_key,
    CAST("agent ID" AS VARCHAR) AS agent_key,

    -- Attributes
    "COMPLAINT_catego ry" AS complaint_category,
    resolutionstatus AS resolution_status,

    -- Timestamps
    CAST(call_start_time AS TIMESTAMP) AS call_timestamp,
    CAST(call_end_time AS TIMESTAMP) AS call_end_timestamp,

    -- Metadata (tracking lineage)
    CAST(callLogsGenerationDate AS DATE) AS dbt_load_date,
    filename AS source_file_path

FROM read_parquet(
        's3://coretelecoms-raw-data-lake-isaac/raw/call_logs/*.parquet'
)