variable "region" {
  default = "us-east-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-terraform-demo-bucket-12345-nikunj"
}

