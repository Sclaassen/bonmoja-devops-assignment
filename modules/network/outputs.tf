## Outputs for the VPC module

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "name" {
  description = "The name of the VPC"
  value       = aws_vpc.main.tags["Name"]
}
output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs for ECS"
  value       = aws_subnet.private[*].id
}


output "vpc_security_group_id" {
  description = "Security group ID for shared VPC access"
  value       = aws_security_group.vpc-security-group.id
}

