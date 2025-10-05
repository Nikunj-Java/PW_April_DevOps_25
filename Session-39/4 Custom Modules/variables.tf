variable "aws_region" {
    description = "AWS region to deploy resources"
    type        = string
    default     = "us-east-1"
  
}

variable "cidr_blocks" {
  description = "CIDR blocks for the VPC"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "vpc_name" {
    description = "Name of the VPC"
    type        = string
    default     = "Terraform-Module-VPC"
}