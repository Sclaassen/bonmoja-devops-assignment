## Variables for the monitoring module

variable "environment" {}

variable "rds_instance_id" {
  description = "RDS instance identifier for monitoring"
  type        = string
}

variable "sqs_queue_name" {}
