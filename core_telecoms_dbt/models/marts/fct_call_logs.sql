-- models/marts/fct_call_logs.sql
-- Materialized as a table in dbt_project.yml (marts config)

SELECT
    -- Foreign Keys (FKs) to Dimensions
    call_key,
    customer_key,
    agent_key,
    
    -- Date/Time Attributes
    call_timestamp,
    call_end_timestamp,

    -- Fact Attributes / Measures
    -- Calculate duration in seconds using DuckDB's timestamp subtraction
    CAST(date_diff('second', call_timestamp, call_end_timestamp) AS INTEGER) AS call_duration_seconds,
    complaint_category,
    resolution_status,
    
    -- Audit Column
    dbt_load_date,
    source_file_path

FROM {{ ref('stg_call_logs') }}
-- A fact table typically doesn't need a WHERE clause unless filtering known bad data.