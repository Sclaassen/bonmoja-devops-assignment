## Outputs for IAM module

output "ecs_task_execution_role_arn" {
  description = "ARN for ECS Task Execution Role (set as execution_role_arn in ECS task definitions)"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "ARN for ECS Task Role (set as task_role_arn in ECS task definitions)"
  value       = aws_iam_role.ecs_task_role.arn
}