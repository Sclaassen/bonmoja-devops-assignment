# This file contains the variable definitions for the ECS module.
# ECS task definition variables
variable "aws_region" {}
variable "environment" {}
variable "ecs_cluster_name" {}
variable "security_group_id" {
  description = "Security group ID for ECS service"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID for ALB and Target Group"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for ECS"
  type        = list(string)
}

variable "ecs_task_execution_role_arn" {
  description = "ARN for ECS Task Execution Role"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN for ECS Task Role"
  type        = string
}

