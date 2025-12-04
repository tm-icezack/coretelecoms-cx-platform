-- models/marts/fct_master_interactions.sql

{{ config(
    materialized='table',
    tag='master_fact'
) }}

-- 1. First CTE: UNION ALL the three fact tables
WITH combined_interactions AS (
    -- 1. Call Logs Data
    SELECT
        call_key AS interaction_key,
        customer_key,
        agent_key,
        call_timestamp AS interaction_timestamp,
        call_duration_seconds AS duration_seconds,
        NULL AS resolution_time_hours,
        'Call Log' AS channel,
        complaint_category,
        resolution_status
    FROM {{ ref('fct_call_logs') }}

    UNION ALL

    -- 2. Social Media Data
    SELECT
        complaint_key AS interaction_key,
        customer_key,
        agent_key,
        request_timestamp AS interaction_timestamp,
        NULL AS duration_seconds,
        resolution_time_hours,
        'Social Media' AS channel,
        complaint_category,
        resolution_status
    FROM {{ ref('fct_social_media') }}

    UNION ALL

    -- 3. Web Forms Data
    SELECT
        request_key AS interaction_key,
        customer_key,
        agent_key,
        request_timestamp AS interaction_timestamp,
        NULL AS duration_seconds,
        resolution_time_hours,
        'Web Form' AS channel,
        complaint_category,
        resolution_status
    FROM {{ ref('fct_web_forms') }}
) -- <-- NO COMMA OR SEMICOLON HERE

-- 2. Second CTE (FIX: MUST START with a comma after the first CTE definition)
, final_interactions AS (
    SELECT
        t1.*
    FROM combined_interactions t1
    INNER JOIN {{ ref('dim_customers') }} t2
        ON t1.customer_key = t2.customer_key
)

-- Final SELECT statement
SELECT * FROM final_interactions