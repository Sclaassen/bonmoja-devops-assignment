## Outputs for DynamoDB Table

output "dynamo_db_arn" {
  value = aws_dynamodb_table.main.arn
}

output "dynamo_db_name" {
  value = aws_dynamodb_table.main.name
}

output "dynamo_db_stream_arn" {
  value = aws_dynamodb_table.main.stream_arn
}

output "dynamo_db_table_name" {
  value = aws_dynamodb_table.main.name
}

output "dynamo_db_table_id" {
  value = aws_dynamodb_table.main.id
}