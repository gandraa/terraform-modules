resource "aws_iam_role" "role" {
  name               = var.role_name

  assume_role_policy = file("${path.module}/../../assets/policies/${var.assume_role_policy_file}")
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
  policy_arn = each.value["arn"]
}

resource "aws_iam_role_policy_attachment" "existing_policy_attach" {
  role       = aws_iam_role.role.name
  for_each   = var.policy_arn
  policy_arn = each.value
}