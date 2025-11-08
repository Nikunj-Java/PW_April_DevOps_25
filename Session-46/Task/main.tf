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

resource "aws_instance" "flask_server" {
    ami = "ami-0157af9aea2eef346"  # Amazon Linux 2 AMI
    instance_type = "t2.micro"
    key_name = file("/mnt/C/Users/NEW/.ssh/id_rsa.pub")
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [aws_security_group.sg.id]
    associate_public_ip_address = true
    user_data = file("deploy_flask.sh")

    tags = {
        Name = "Flask-dynamo-instance-app"
        Environment = "Dev"
    }
}