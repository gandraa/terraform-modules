# ===================================================== #
# - - - - - - - - - - - ECR REPOSITORY - - - - - - - -  #
# ===================================================== #
resource "aws_ecr_repository" "ecr_repository" {
  for_each             = { for parameters in var.ecr_parameters : parameters.ecr_name => parameters.permitted_account }
  name                 = each.key
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

# ===================================================== #
# - - - - - - - - - - -  ECR POLICY  - - - - - - - - -  #
# ===================================================== #
resource "aws_ecr_repository_policy" "ecr_policy" {
  for_each = { for parameters in var.ecr_parameters : parameters.ecr_name => parameters.permitted_account
  if parameters.permitted_account != "" }
  repository = each.key
  policy     = templatefile("${path.module}/../assets/policies/ecr-policy.json", { account = each.value })
}