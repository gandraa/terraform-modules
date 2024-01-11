output "release" {
  value       = helm_release.helm_deployment
  sensitive   = true
  description = "Helm release values as Terraform object"
}