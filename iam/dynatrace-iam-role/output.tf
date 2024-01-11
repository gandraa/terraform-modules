output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "role_name" {
  value = aws_iam_role.role.name
}