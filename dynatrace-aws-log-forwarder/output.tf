output "lambda_arn" {
  description = "Lambda ARN"
  value       = aws_lambda_function.lambda_dynatrace.arn
}

output "firehose_arn" {
  description = "Firehose ARN"
  value       = aws_kinesis_firehose_delivery_stream.firehose_log_streams.arn
}

output "cloudwatch_logs_role_arn" {
  description = "CloudWatch Logs role ARN allowing streaming to Firehose"
  value       = aws_iam_role.cloudwatch_logs_role.arn
}

output "ec2_activegate_hostname" {
  description = "EC2 ActiveGate Hostname"
  value       = "Not applicable"
}
