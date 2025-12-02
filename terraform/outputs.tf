output "warehouse_name" {
  value = snowflake_warehouse.coretelecoms_warehouse.name
}

output "database_name" {
  value = snowflake_database.coretelecoms_db.name
}

output "schema_name" {
  value = snowflake_schema.raw_schema.name
}
