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
    -- Calculate resolution time in hours
    CAST(date_diff('hour', request_timestamp, resolution_timestamp) AS INTEGER) AS resolution_time_hours,
    
    -- Categorical Attributes
    complaint_category,
    resolution_status,
    platform_type,
    
    -- Audit Columns
    dbt_load_date
    -- Note: Removed source_file_path, which was in the last error, but you'll want to add it back for completeness!
    -- If the staging model includes it, add it here: source_file_path

FROM {{ ref('stg_social_media') }}