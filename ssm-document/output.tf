
output "created_date" {
  description = "The date the document was created."
  value       = try(aws_ssm_document.ssm_document.created_date, "")
}

output "document_status" {
  description = "\"Creating\", \"Active\" or \"Deleting\". The current status of the document."
  value       = try(aws_ssm_document.ssm_document.status, "")
}

output "platform_types" {
  description = "A list of OS platforms compatible with this SSM document."
  value       = try(aws_ssm_document.ssm_document.platform_types, "")
}

output "latest_version" {
  description = "The latest version of the document."
  value       = try(aws_ssm_document.ssm_document.latest_version, "")
}