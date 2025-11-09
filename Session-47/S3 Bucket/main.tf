# create S3 bucket
provider "aws" {
    region ="us-east-1"
}

# generate unique bucket name
resource "random_id" "bucket_name" {
    byte_length = 4
}

# create S3 bucket
resource "aws_s3_bucket" "upload_bucket" {
    bucket = "flask-upload-bucket-${random_id.bucket_name.hex}"
    force_destroy = true

    tags = {
        Name        = "FlaskUploadBucket"
        Environment = "Dev"
        purpose     = "FlaskUploads"
    }
}

#output bucket name
output "bucket_name" {
    value = aws_s3_bucket.upload_bucket.bucket
}