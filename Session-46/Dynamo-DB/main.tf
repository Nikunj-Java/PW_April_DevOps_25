provider "aws" {
    region = "us-east-1"
}

resource "aws_dynamodb_table" "userstable" {
    name = var.tablename
    billing_mode = "PAY_PER_REQUEST"

    attribute {
        name = "UserID"
        type = "S"
    }
    

    hash_key = "UserID"
    range_key = "Email"
    attribute {
        name = "Email"
        type = "S"
    }

    tags = {
      Name = "UsersTable"
      Environment = "Dev"
    }

}