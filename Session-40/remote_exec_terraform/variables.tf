variable "aws_region" {
    default = "us-east-1"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key_name" {
    description = "Default Key Name of aws instance"
    default = "test"
}
