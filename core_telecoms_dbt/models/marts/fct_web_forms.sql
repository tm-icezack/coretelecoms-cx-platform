-- models/marts/fct_web_forms.sql
-- Materialized as a table in dbt_project.yml (marts config)

SELECT
    -- Foreign Keys (FKs) to Dimensions
    request_key,
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
    
    -- Audit Columns
    dbt_load_date,
    source_file_path

FROM {{ ref('stg_web_forms') }}