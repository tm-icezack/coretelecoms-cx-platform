{{ config(materialized='view') }}

SELECT
    VALUE:"NamE"::STRING AS full_name,
    VALUE:"experience"::STRING AS experience_level,
    VALUE:"iD"::STRING AS agent_key,
    VALUE:"state"::STRING AS state,
    METADATA$FILENAME AS source_file_path
FROM RAW.AGENTS_EXT