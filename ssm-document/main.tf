# ===================================================== #
# - - - - - - - - - Data  Section  - - -  - - - - - - - #
# ===================================================== #
data "aws_ssm_parameter" "ssm_parameters" {
  for_each = toset(var.ssm_parameter_variables)
  name = each.key
}

# ===================================================== #
# - - - - - - - - -   Local Section   - - - - - - - - - #
# ===================================================== #
locals{
  ssm_values = { for a in data.aws_ssm_parameter.ssm_parameters : a.name => a.value }
  all_variables = merge(local.ssm_values, var.value_map, {"team_name" = var.team_name, "environment" = var.environment})
}


# ===================================================== #
# - - - - - - - - - - SSM DOCUMENT  - - - - - - - - - - #
# ===================================================== #
resource "aws_ssm_document" "ssm_document" {
  name = var.name

  document_format = var.document_format
  document_type   = var.document_type
  target_type     = var.target_type
  version_name    = var.version_name

  content = templatefile("${path.module}/../assets/ssm_documents/${var.content_file}", local.all_variables)
}

resource "aws_ssm_association" "ssm_document_execution" {
  name             = aws_ssm_document.ssm_document.name
 # Cron expression
  schedule_expression = "cron(0 0/2 * * ? *)"


  targets {
    key    = var.targets.key
    values = var.targets.values
  }
}