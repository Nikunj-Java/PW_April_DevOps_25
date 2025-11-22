######################################################################
# AWS Provider
######################################################################
provider "aws" {
    region = "us-east-1"
}

######################################################################
# DynamoDB Table
######################################################################}

resource "aws_dynamodb_table" "users" {
    name        = "Users"
    billing_mode = "PAY_PER_REQUEST"

    #partition key
    hash_key = "Email"
    attribute {
      name="Email"
      type = "S"                #s= String

    }   
    tags    =   {
        Project="UserManagement"
        Owner= "Nikunj"
    }
  
}

######################################################################
# Output
######################################################################
output "table_name" {
    value = aws_dynamodb_table.users.name
  
}
