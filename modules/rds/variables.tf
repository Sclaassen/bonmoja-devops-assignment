## Variables for the RDS module

variable "environment" {}
variable "aws_region" {}
variable "subnet_ids" {
  type        = list(any)
  description = "Subnet ids"
}

variable "vpc_id" {
  description = "The VPC id"
}

//variable "allowed_security_group_id" {
//  description = "The allowed security group id to connect on RDS"
//}

variable "allocated_storage" {
  description = "The storage size in GB"
}

variable "instance_class" {
  description = "The instance type"
}

variable "multi_az" {
  description = "Muti-az allowed?"
}

variable "database_name" {
  default     = "dummy_data"
  description = "The database name"
}

variable "database_username" {
  description = "The username of the database"
}

variable "database_password" {
  description = "The password of the database"
}

variable "ecs_security_group_id" {
  description = "The security group ID for the ECS service/tasks that need access to the database."
  type        = string
}
