variable "region" {
    default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  default = "ami-0360c520857e3138f" # Amazon Linux 2 AMI
}