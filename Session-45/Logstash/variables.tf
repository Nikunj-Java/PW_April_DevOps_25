variable "region" {
    default = "us-east-1"
  

}

variable "ami_id" {
    description = "Amazon Linux 2 AMI ID For Your Region"
    default = "ami-0bdd88bd06d16ba03"
  
}

variable "instance_type" {
    description = "EC2 Instance Type"
    default     = "t2.micro"
  
}