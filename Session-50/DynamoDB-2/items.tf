######################################################################
# Sample Users 1
############################################### #######################

resource "aws_dynamodb_table_item" "user1" {
    table_name = aws_dynamodb_table.users.name
    hash_key = "Email"
    item = <<ITEM
    {
    "Email"     :{"S" :"nikunj@gmail.com"},
    "Password"  :{"S" :"Pass@123"},
    "Name"      :{"S":"Nikunj Soni"},
    "Designation":{"S":"Developer"}
    }
    ITEM


}
######################################################################
# Sample Users 2
######################################################################

resource "aws_dynamodb_table_item" "user2" {
    table_name = aws_dynamodb_table.users.name
    hash_key = "Email"
    item = <<ITEM
    {
    "Email"     :{"S" :"ajaykumar@gmail.com"},
    "Password"  :{"S" :"Ajay@123"},
    "Name"      :{"S":"Ajay Kumar"},
    "Designation":{"S":"DevOps Enginner"}
    }
    ITEM


}