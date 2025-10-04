provider "aws" {
    region = var.region
}
resource "aws_dynamodb_table" "simple_table" {
    name = var.aws_dynamodb_table_name
    billing_mode = var.billing_mode
    hash_key = var.hash_key

    attribute {
        name = var.attribute_name
        type = "S"
    }

   
}
