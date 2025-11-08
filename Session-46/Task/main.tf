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
# Create a Key Pair 
resource "aws_key_pair" "flask_key" {
  key_name   = "flask-key"
  public_key = file("/mnt/c/Users/NEW/.ssh/id_rsa.pub")
}

# Create a Security Group
resource "aws_security_group" "flask_sg" {
  name        = "flask-sg"
  description = "Allow HTTP and Flask port access"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 Instance with Flask app
resource "aws_instance" "flask_app" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.flask_key.key_name
  security_groups = [aws_security_group.flask_sg.name]
  user_data= file("deploy_flask.sh")
}

output "flask_app_url" {
  value = "http://${aws_instance.flask_app.public_ip}:5000"
}
