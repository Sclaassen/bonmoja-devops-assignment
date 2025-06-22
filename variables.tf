## Variables for AWS infrastructure deployment

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}
variable "environment" {
  description = "Environment for the infrastructure (e.g., demo, dev, staging, prod)"
  type        = string
  validation {
    condition     = can(regex("^(demo|dev|staging|prod)$", var.environment))
    error_message = "Environment must be one of: demo, dev, staging, prod."
  }
}

variable "rds_instance_class" {
  description = "value for the RDS instance class"
  type        = string

}
variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_password" {
  description = "The database password"
  type        = string
}

variable "sns_subscription_email" {
  description = "Email address for SNS topic subscription"
  type        = string
}

variable "rds_allocated_storage" {
  description = "The amount of storage (in GB) to allocate for the RDS instance."
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Deploy RDS instance in multiple Availability Zones for high availability"
  type        = bool
  default     = true
}

