provider "aws" {
  region = "us-east-1"
}

# Create S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "nikunj-terraform-bucket-12345" # globally unique
  acl    = "private"

  tags = {
    Name        = "MyDemoBucket"
    Environment = "Dev"
  }
}

# Upload index.html to the bucket
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "index.html"      # Object name in S3
  source       = "index.html"      # Local file path
  content_type = "text/html"
}
