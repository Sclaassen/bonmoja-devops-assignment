## Variables for the monitoring module

variable "environment" {}

variable "rds_instance_id" {
  description = "RDS instance identifier for monitoring"
  type        = string
}

variable "sqs_queue_name" {}

variable "sns_subscription_email" {
  description = "Email address for SNS topic subscription for alerts"
  type        = string
}
