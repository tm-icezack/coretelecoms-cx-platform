{{ config(materialized='view') }}

SELECT
   request_id AS request_key,
    "customeR iD" AS customer_key,
    CAST("agent ID" AS VARCHAR) AS agent_key,

    "COMPLAINT_catego ry" AS complaint_category,
    resolutionstatus AS resolution_status,

    -- FIX: Use NULLIF to handle empty strings (e.g., in resolution_date)
    CAST(NULLIF(request_date, '') AS TIMESTAMP) AS request_timestamp,
    CAST(NULLIF(resolution_date, '') AS TIMESTAMP) AS resolution_timestamp,

    CAST(webFormGenerationDate AS DATE) AS dbt_load_date,
    filename AS source_file_path

FROM read_parquet(
    's3://coretelecoms-raw-data-lake-isaac/raw/web_forms/*.parquet'
)