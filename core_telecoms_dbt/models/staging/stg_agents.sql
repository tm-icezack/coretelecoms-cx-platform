-- models/staging/stg_agents.sql

SELECT
    -- 1. Rename and clean up inconsistent capitalization
    "iD" AS agent_key,
    "NamE" AS full_name,
    "experiencE" AS experience_level,
    state
    -- 2. Add source tracking metadata (dbt best practice)
    -- This helps trace data back to its source file if needed
    -- (The following line might need adjustment based on your actual data structure)
    -- _file AS source_file_path 

FROM read_parquet('s3://coretelecoms-raw-data-lake-isaac/raw/agents/*.parquet')