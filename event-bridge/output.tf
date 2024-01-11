output "rule_name" {
  description = "The name of the rule created."
  value = aws_cloudwatch_event_rule.eventbridge_rule.name
}