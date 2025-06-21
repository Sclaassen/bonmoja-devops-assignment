## This Terraform configuration sets up an AWS environment with IAM, RDS, ECS, DynamoDB, SNS, and monitoring.

# Update your Terraform backend block (in main.tf or backend.tf) to match the workflow, for clarity and local use:
# The workflow will override these values with the -backend-config flags.
terraform {
  backend "s3" {
    bucket         = "demo-terraform-tf-state-bucket"
    key            = "devops-assignment/demo/terraform.tfstate"
    region         = "af-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"
}

module "network" {
  source      = "./modules/network"
  environment = var.environment
}

module "rds" {
  source            = "./modules/rds"
  environment       = var.environment
  allocated_storage = "20"
  database_name     = var.db_name
  database_username = var.db_username
  database_password = var.db_password
  subnet_ids        = module.network.private_subnets
  vpc_id            = module.network.vpc_id
  instance_class    = var.rds_instance_class
  multi_az          = true
}

module "ecs" {
  source                      = "./modules/ecs"
  aws_region                  = var.aws_region
  environment                 = var.environment
  vpc_id                      = module.network.vpc_id
  security_group_id           = module.network.vpc_security_group_id
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn
  ecs_cluster_name            = "${var.environment}-ecs-cluster"
  public_subnets              = module.network.public_subnets
}

module "dynamodb" {
  source         = "./modules/dynamodb"
  table_name     = "sessions-${var.environment}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "session_id"
  attribute_type = "S"
  environment    = var.environment
}

module "messaging" {
  source                 = "./modules/messaging"
  sns_subscription_email = var.sns_subscription_email
  environment            = var.environment
}

module "monitoring" {
  source          = "./modules/monitoring"
  rds_instance_id = module.rds.rds_instance_id
  sqs_queue_name  = "${var.environment}-sqs-queue"
  environment     = var.environment
  sns_subscription_email = var.sns_subscription_email
}






