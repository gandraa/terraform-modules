data "aws_caller_identity" "current" {}

resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = templatefile("${path.module}/../../assets/policies/dynatrace-assume-role.json", { account = var.dynatrace_monitoring_account_id, externalid = var.dynatrace_external_id })
}

locals {
  policies = {
    "${var.customer_managed_policy_name}" = file("${path.module}/../../assets/policies/${var.customer_managed_policy_file}")
  }
}

resource "aws_iam_policy" "customer_managed_policy" {
  name       = each.key
  for_each   = local.policies
  policy     = each.value
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.role.name
  for_each   = aws_iam_policy.customer_managed_policy
  policy_arn = aws_iam_policy.customer_managed_policy[each.key].arn
}