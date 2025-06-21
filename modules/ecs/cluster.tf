## This module creates an ECS cluster in AWS.

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.environment}-ecs-cluster"
}
