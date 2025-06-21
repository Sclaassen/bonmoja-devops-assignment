## This Terraform module sets up an SQS queue and an SNS topic with a subscription.

resource "aws_sqs_queue" "main" {
  name = "${var.environment}-main-queue"
}

resource "aws_sns_topic" "main" {
  name = "${var.environment}-main-topic"
}

resource "aws_sns_topic_subscription" "main" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "email"
  endpoint  = var.sns_subscription_email
}


