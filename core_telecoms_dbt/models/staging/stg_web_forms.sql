-- models/staging/stg_web_forms.sql

SELECT
    -- Keys and Identifiers
    request_id AS request_key,
    "customeR iD" AS customer_key,
    CAST("agent ID" AS VARCHAR) AS agent_key,

    -- Attributes
    "COMPLAINT_catego ry" AS complaint_category,
    resolutionstatus AS resolution_status,

    -- Timestamps
    CAST(request_date AS TIMESTAMP) AS request_timestamp,
    CAST(resolution_date AS TIMESTAMP) AS resolution_timestamp,

    -- Metadata
    CAST(webFormGenerationDate AS DATE) AS dbt_load_date

    -- Column1 is dropped
    
FROM read_parquet('s3://coretelecoms-raw-data-lake-isaac/raw/web_forms/*.parquet')