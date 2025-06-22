# Outputs for the ECS module
# This file defines the outputs for the ECS module, which can be used to retrieve information about the ECS resources created by this module.
output "ecs_cluster_name" {
  value       = aws_ecs_cluster.ecs-cluster.name
  description = "The name of the ECS cluster"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.ecs-cluster.arn
  description = "The ARN of the ECS cluster"
}

output "ecs_service_name" {
  value       = aws_ecs_service.http_echo.name
  description = "The name of the ECS service"
}

output "ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.http_echo.arn
  description = "The ARN of the ECS task definition"
}

output "alb_dns_name" {
  value       = aws_lb.ecs_alb.dns_name
  description = "The DNS name of the ECS service load balancer"
}

output "ecs_sg_id" {
  value       = aws_security_group.ecs_sg.id
  description = "The ID of the ECS security group."
}