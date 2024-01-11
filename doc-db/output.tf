output "master_username" {
  description = "The master username for the database"
  value       = try(aws_docdb_cluster.docdb.master_username, "")
  sensitive   = true
}

output "master_password" {
  description = "The master password"
  value       = try(aws_docdb_cluster.docdb.master_password, "")
  sensitive   = true
}

output "cluster_name" {
  value       = aws_docdb_cluster.docdb.cluster_identifier
  description = "Cluster Identifier"
}

output "cluster_members" {
  value       = aws_docdb_cluster.docdb.cluster_members
  description = "Cluster Members"
}

output "cluster_resource_id" {
  value       = aws_docdb_cluster.docdb.cluster_resource_id
  description = "Cluster Resource ID"
}

output "arn" {
  value       = aws_docdb_cluster.docdb.arn
  description = "Amazon Resource Name (ARN) of the cluster"
}

output "endpoint" {
  value       = aws_docdb_cluster.docdb.endpoint
  description = "Endpoint of the DocumentDB cluster"
}

output "reader_endpoint" {
  value       = aws_docdb_cluster.docdb.reader_endpoint
  description = "A read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas"
}

output "security_group_id" {
  description = "ID of the DocumentDB cluster Security Group"
  value       = aws_security_group.docdb.id
}

output "security_group_arn" {
  description = "ARN of the DocumentDB cluster Security Group"
  value       = aws_security_group.docdb.arn
}

output "security_group_name" {
  description = "Name of the DocumentDB cluster Security Group"
  value       = aws_security_group.docdb.name
}