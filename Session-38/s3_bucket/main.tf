provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
    bucket ="nikunj-terraform-bucket-12345" # bucket name must be globally unique
    acl ="private"
    tags={
        Name ="MyDemoBucket"
        Environment="Dev"
    }
}