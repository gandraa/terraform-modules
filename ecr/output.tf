output "registry_id" {
  value       = values(aws_ecr_repository.ecr_repository)[*].registry_id
  description = "Registry ID."
}

output "repository_name" {
  value       = values(aws_ecr_repository.ecr_repository)[*].name
  description = "Name of repository."
}

output "repository_url" {
  value       = values(aws_ecr_repository.ecr_repository)[*].repository_url
  description = "URL of repository."
}