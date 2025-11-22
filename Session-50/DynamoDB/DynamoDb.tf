provider "aws"{
    region="us-east-1"
}

resource "aws_dynamodb_table" "employees" {
    name    = "Employees"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "EmpID"
    attribute {
        name = "EmpID"
        type = "S"
    }
  
}