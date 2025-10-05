variable "aws_region" {
    description = "AWS Region"
    default = "us-east-1"
  
}

variable "ami_id" {
    description = "AMI ID for the EC2 instance"
    default = "ami-0360c520857e3138f"
}

variable "instance_type" {
    description = "EC2 Instance Type"
    default = "t2.micro"
  
}

variable "key_name" {
    description = "EC2 Key pair Name"
    type = string
  
}