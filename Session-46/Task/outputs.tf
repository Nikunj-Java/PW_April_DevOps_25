output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = aws_dynamodb_table.userstable.name
}

output "dynamodb_table_arn" {
    description = "ARN of the DynamoDB Table"
    value = aws_dynamodb_table.userstable.arn
  
}