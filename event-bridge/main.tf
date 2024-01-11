# ===================================================== #
# - - - - - - - - - AMAZON EVENTBRIDGE - - - - - - - -  #
# ===================================================== #

resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
  name          = join("_", [var.eventbridge_name, var.namespace])
  description   = var.eventbridge_description
  event_pattern = <<EOF
{
  "source": ["aws.ssm"],
  "detail-type": ["Parameter Store Change"],
  "detail": {
    "name": ${jsonencode(var.parameter_names)},
    "operation": ["Update"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "target" {
  target_id = "eventbridge-lambda-target-${var.namespace}"
  rule      = aws_cloudwatch_event_rule.eventbridge_rule.name
  arn       = aws_lambda_function.eventbridge_lambda.arn
}


# ===================================================== #
# - - - - - - - - AMAZON LAMBDA FUNCTION - - - - - - -  #
# ===================================================== #

resource "aws_lambda_function" "eventbridge_lambda" {
  role          = var.role_arn
  function_name = join("-", [var.function_name, var.namespace])
  handler       = var.handler
  runtime       = var.runtime
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key

  environment {
    variables = {
      CLUSTER_NAME = var.eks_cluster_name,
      NAMESPACE    = var.namespace,
    }
  }

}

resource "aws_lambda_permission" "eventbridge_lambda_permission" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eventbridge_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.eventbridge_rule.arn
}