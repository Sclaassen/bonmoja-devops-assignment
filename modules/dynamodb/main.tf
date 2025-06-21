## This module creates a DynamoDB table with the specified configuration.

resource "aws_dynamodb_table" "main" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = var.attribute_type
  }

  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}

