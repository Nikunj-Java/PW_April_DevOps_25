variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
  
}
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-terraform-bucket-12345-0510"
}
variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "dev"
}
variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0360c520857e3138f"
}
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}
