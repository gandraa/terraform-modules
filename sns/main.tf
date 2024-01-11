# ===================================================== #
# - - - - - - - - - - - - SNS TOPIC - - - - - - - - - - #
# ===================================================== #
resource "aws_sns_topic" "sns_topic" {
  name = var.topic_name
}

# ===================================================== #
# - - - - - - -  SNS TOPIC SUBSCRIPTION - - - - - - - - #
# ===================================================== #
resource "aws_sns_topic_subscription" "sns_topic_subscription" {
  endpoint  = var.endpoint
  protocol  = var.protocol
  topic_arn = aws_sns_topic.sns_topic.arn
}