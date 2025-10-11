variable "aws_region" {
    default = "us-east-1"
}

variable "instance_type" {
    default = "t2.micro"  
}

variable "key_name" {
    default = "test"
    description = "Existing AWS key pair name ti use for SSH "
}