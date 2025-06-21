## Outputs for the messaging module

output "sqs_queue_arn" {
  value = aws_sqs_queue.main.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.main.arn
}