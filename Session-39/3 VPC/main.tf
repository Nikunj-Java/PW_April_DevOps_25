provider "aws" {
    region = var.aws_region
  
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "MyVPC" 
    }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_name
    Environment = var.environment

  }
}

resource "aws_instance" "my_ec2" {
    ami           = var.ami_id
    instance_type = var.instance_type
    
    tags = {
        Name = "MyTerraformEC2"
    }
  
}