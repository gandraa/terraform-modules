output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = try(aws_db_instance.rds_instance.address, "")
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = try(aws_db_instance.rds_instance.arn, "")
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = try(aws_db_instance.rds_instance.endpoint, "")
}

output "db_instance_engine" {
  description = "The database engine"
  value       = try(aws_db_instance.rds_instance.engine, "")
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = try(aws_db_instance.rds_instance.id, "")
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = try(aws_db_instance.rds_instance.resource_id, "")
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = try(aws_db_instance.rds_instance.status, "")
}

output "db_instance_name" {
  description = "The database name"
  value       = try(aws_db_instance.rds_instance.db_name, "")
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = try(aws_db_instance.rds_instance.username, "")
  sensitive   = true
}

output "db_instance_password" {
  description = "The master password"
  value       = try(aws_db_instance.rds_instance.password, "")
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = try(aws_db_instance.rds_instance.port, "")
}
