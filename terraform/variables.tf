# variables.tf
variable "postgres_db_url" {
  description = "Postgres Web Form DB URL"
  type        = string
  sensitive   = true
}
