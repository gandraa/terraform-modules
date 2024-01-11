output "iam_roles" {
  description = "ARNs of K8S IAM Roles."
  value = {
    for role in aws_iam_role.iam_roles : role.name => role.arn
  }
}