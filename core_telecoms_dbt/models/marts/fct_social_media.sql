-- models/marts/fct_social_media.sql
-- Materialized as a table in dbt_project.yml (marts config)

SELECT
    -- Foreign Keys (FKs) to Dimensions
    complaint_key,
    customer_key,
    agent_key,
    
    -- Date/Time Attributes
    request_timestamp,
    resolution_timestamp,

    -- Metrics / Measures
    -- Calculate resolution time in hours using Snowflake's DATEDIFF function
    DATEDIFF('hour', request_timestamp, resolution_timestamp) AS resolution_time_hours,
    
    -- Categorical Attributes
    complaint_category,
    resolution_status,
    platform_type,
    
    -- Audit Columns
    dbt_load_date,
    -- Added the source_file_path back for data lineage auditing
    source_file_path 

FROM {{ ref('stg_social_media') }}