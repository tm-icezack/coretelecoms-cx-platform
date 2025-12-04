-- models/marts/dim_agents.sql
-- Materialization is set to 'table' in dbt_project.yml (marts config)

WITH ranked_agents AS (
    SELECT
        *,
        -- Use a window function to rank records for each agent
        -- Assuming a single agent_key has multiple historical records (if applicable)
        ROW_NUMBER() OVER (
            PARTITION BY agent_key 
            ORDER BY source_file_path DESC -- Using filename as a proxy for freshness/uniqueness
        ) AS rn
    FROM {{ ref('stg_agents') }}
)

SELECT
    agent_key,
    full_name,
    experience_level,
    state,
    source_file_path
FROM ranked_agents
-- Filter to keep only the primary/latest record for each agent_key
WHERE rn = 1