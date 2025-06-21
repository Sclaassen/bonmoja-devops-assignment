## Outputs for the RDS module

output "rds_address" {
  value = aws_db_instance.rds.address
}

output "rds_user" {
  value = aws_db_instance.rds.username
}


output "db_access_sg_id" {
  value = aws_security_group.db_access_sg.id
}

output "rds_instance_id" {
  value = aws_db_instance.rds.id
}

output "database_name" {
  value = aws_db_instance.rds.db_name
}
