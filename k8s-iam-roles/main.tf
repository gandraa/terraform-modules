# ===================================================== #
# - - - - - - - - - K8S IAM Roles  - - - - - - - - - -  #
# ===================================================== #

# ===================================================== #
# - - - - - - - - -   Local Section   - - - - - - - - - #
# ===================================================== #
locals {
  all_partition = {
    "aws"        = "ec2.amazonaws.com"
    "aws-us-gov" = "ec2.amazonaws.com"
    "aws-cn"     = "ec2.amazonaws.com.cn"
    "aws-iso"    = "ec2.c2s.ic.gov"
    "aws-iso"    = "ec2.sc2s.sgov.gov"
  }

  aws_service = lookup(local.all_partition, data.aws_partition.current.partition)

  iam_roles = flatten([
    for role in var.iam_roles : [
      for policy in role.policies : {
        id        = sum([length(role.role_name), length(policy.file_name), length(policy.resources)])
        role      = role.role_name
        policy    = policy.file_name
        resources = policy.resources
    }]
  ])

  managed_policies = flatten([
    for role in var.iam_roles : [
      for policy in role.managed_policies : {
        role      = role.role_name
        policy    = policy
    }]
  ])
}
# ===================================================== #
# - - - - - - - - -  Data Section   - - - - - - - - - - #
# ===================================================== #
data "aws_partition" "current" {}

# ===================================================== #
# - - - - - - - -   IAM  Role - - - - - - - - - - - - - #
# ===================================================== #
resource "aws_iam_role" "iam_roles" {
  for_each = { for role in var.iam_roles : role.role_name => role.namespace }
  name     = join("-", [var.eks_environment, "infrastructure", each.key, var.eks_account])

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : "arn:aws:iam::${var.account_id}:oidc-provider/${var.oidc}"
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringEquals" : {
              "${var.oidc}:sub" : "system:serviceaccount:${each.value}:${each.key}"
            }
          }
        }
      ]
    }
  )
}

# ===================================================== #
# - - - - - - - -    Custom  Policies - - - - - - - - - #
# ===================================================== #
resource "aws_iam_policy" "iam_policies" {
  for_each = { for policy in local.iam_roles : policy.id => policy }
  name     = join("-", [replace(each.value.policy, ".json", ""), each.key])
  policy   = templatefile("${path.module}/../assets/policies/${each.value.policy}", { resources = each.value.resources })
}

# ===================================================== #
# - - - - - -   Attach IAM Policies to Role - - - - - - #
# ===================================================== #
resource "aws_iam_role_policy_attachment" "eks_managed_policy_attachments" {
  for_each = { for role in local.managed_policies : role.role => role.policy}
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/${each.value}"
  role       = join("-", [var.eks_environment, "infrastructure", each.key, var.eks_account]) 

  depends_on = [aws_iam_role.iam_roles]
}
resource "aws_iam_role_policy_attachment" "iam_policy_attachments" {
  for_each   = { for policy in local.iam_roles : policy.id => policy }
  policy_arn = join("-", [replace("arn:aws:iam::${var.account_id}:policy/${each.value.policy}", ".json", ""), each.key])
  role       = join("-", [var.eks_environment, "infrastructure", each.value.role, var.eks_account])

  depends_on = [
    aws_iam_role.iam_roles,
    aws_iam_policy.iam_policies
  ]
}