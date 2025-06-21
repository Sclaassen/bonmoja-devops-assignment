## Variables for the messaging module

variable "environment" {
  description = "Environment for the infrastructure (e.g., demo, dev, staging, prod)"
  type        = string

  validation {
    condition     = can(regex("^(demo|dev|staging|prod)$", var.environment))
    error_message = "Environment must be one of: demo, dev, staging, prod."
  }
}

variable "sns_subscription_email" {
  description = "Email address for SNS topic subscription"
  type        = string
}
