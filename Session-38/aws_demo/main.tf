provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "server1" {
    count= 3 # to create multiple instances
    ami           = "ami-0360c520857e3138f" # Amazon Linux 2 AMI
    instance_type = "t2.micro"

    tags = {
        Name = "NikunjVM-${count.index + 1}"
    }
}