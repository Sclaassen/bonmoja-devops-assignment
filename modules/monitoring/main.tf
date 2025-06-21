## Monitoring Module for AWS Resources

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.environment}-http-echo"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "sqs" {
  name              = "/aws/sqs/${var.environment}-main-queue"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "rds" {
  name              = "/rds/${var.environment}-database"
  retention_in_days = 30
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.environment}-rds-cpu-util-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "RDS CPU > 80% for 5 minutes"
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }
  actions_enabled = true
  alarm_actions   = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "sqs_depth_high" {
  alarm_name          = "${var.environment}-sqs-queue-depth-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 600
  statistic           = "Average"
  threshold           = 100
  alarm_description   = "SQS queue depth > 100 for 10 minutes"
  dimensions = {
    QueueName = var.sqs_queue_name
  }
  actions_enabled = true
  alarm_actions   = [aws_sns_topic.alerts.arn]
}

resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-alerts"
}
resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  
  endpoint  = var.sns_subscription_email
}