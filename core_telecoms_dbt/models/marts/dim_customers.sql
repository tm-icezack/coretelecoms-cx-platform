-- models/marts/dim_customers.sql
-- Materialization is set to 'table' in dbt_project.yml

WITH ranked_customers AS (
    -- 1. Select all columns from the staging model
    SELECT
        *,
        -- 2. Use a window function to rank records for each customer
        -- The latest record (highest record_generation_date) gets rank 1
        ROW_NUMBER() OVER (
            PARTITION BY customer_key 
            ORDER BY signup_date DESC
        ) AS rn
    FROM {{ ref('stg_customers') }}
)

SELECT
    customer_key,
    full_name,
    gender,
    birth_date,
    signup_date,
    email,
    full_address,
    -- Add the source file path for auditing, if desired
    source_file_path
FROM ranked_customers
-- 3. Filter to keep only the latest record for each customer_key
WHERE rn = 1