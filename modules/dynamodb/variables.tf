## Variables for the DynamoDB module
variable "environment" {}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string

}

variable "read_capacity" {
  description = "Read capacity units"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units"
  type        = number
  default     = 5
}

variable "hash_key" {
  description = "Primary key name"
  type        = string
}

variable "attribute_type" {
  description = "Primary key type: S (string), N (number)"
  type        = string
}

