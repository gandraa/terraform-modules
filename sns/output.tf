output "topic_arn" {
  description = "The ARN of the SNS topic, as a more obvious property (clone of id)."
  value       = var.topic_name == null ? 0 : aws_sns_topic.sns_topic.arn
}