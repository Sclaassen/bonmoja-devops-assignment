# IAM roles and policies for ECS Fargate tasks
# This module sets up the necessary IAM roles and policies for ECS Fargate tasks, including the task execution role and task role.

variable "ecs_task_role_policy_arns" {
  description = "Additional policies to attach to the ECS Task Role (for app containers, e.g. S3, DynamoDB access)."
  type        = list(string)
  default     = []
}

# ECS Task Execution Role (needed for Fargate: pulls images, logs, etc)
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role_policy.json
}

data "aws_iam_policy_document" "ecs_task_execution_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role (used by your app containers for AWS API access)
resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role_policy.json
}

# Attach optional custom policies for your app container(s)
resource "aws_iam_role_policy_attachment" "ecs_task_role_policies" {
  count      = length(var.ecs_task_role_policy_arns)
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = var.ecs_task_role_policy_arns[count.index]
}




