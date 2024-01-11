output "db_cluster_arn" {
  description = "The ARN of the RDS cluster."
  value       = try(aws_rds_cluster.aurora_rds_cluster.arn, "")
}

output "db_cluster_endpoint" {
  description = "The connection endpoint"
  value       = try(aws_rds_cluster.aurora_rds_cluster.endpoint, "")
}

output "db_cluster_reader_endpoint" {
  description = "The connection endpoint for read-only access."
  value       = try(aws_rds_cluster.aurora_rds_cluster.reader_endpoint, "")
}

output "db_cluster_engine" {
  description = "The database engine"
  value       = try(aws_rds_cluster.aurora_rds_cluster.engine, "")
}

output "db_cluster_engine_version" {
  description = "The database engine"
  value       = try(aws_rds_cluster.aurora_rds_cluster.engine_version_actual, "")
}

output "db_cluster_id" {
  description = "The RDS instance ID"
  value       = try(aws_rds_cluster.aurora_rds_cluster.id, "")
}

output "db_cluster_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = try(aws_rds_cluster.aurora_rds_cluster.cluster_resource_id, "")
}

output "db_name" {
  description = "The database name"
  value       = try(aws_rds_cluster.aurora_rds_cluster.database_name, "")
}

output "db_master_username" {
  description = "The master username for the database"
  value       = try(aws_rds_cluster.aurora_rds_cluster.master_username, "")
  sensitive   = true
}

output "db_master_password" {
  description = "The master password"
  value       = try(random_password.generic_pass.result, "")
  sensitive   = true
}

output "db_cluster_port" {
  description = "The database port"
  value       = try(aws_rds_cluster.aurora_rds_cluster.port, "")
}
