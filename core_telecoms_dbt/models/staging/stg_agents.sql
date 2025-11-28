{{ config(materialized='view') }}

SELECT
    "iD" AS agent_key,
    "NamE" AS full_name,
    "experiencE" AS experience_level,
    state,
    filename AS source_file_path
FROM read_parquet(
    's3://coretelecoms-raw-data-lake-isaac/raw/agents/*.parquet'
)   


