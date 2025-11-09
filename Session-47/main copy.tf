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

# fetch default VPC
data "aws_vpc" "default" {
    default = true
}
# IAM Role for EC2
resource "aws_iam_role" "flask_role" {
    name = "flask-ec2-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })
  
}

# Attach S3 full access policy to the role
resource "aws_iam_role_policy_attachment" "s3_access" {
    role       = aws_iam_role.flask_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#IAM InstanceProfile
resource "aws_iam_instance_profile" "flask_instance_profile" {
    name = "flask-ec2-instance-profile"
    role = aws_iam_role.flask_role.name
}

#Security Group inside Same VPC
resource "aws_security_group" "flask_sg" {
    name        = "flask-ec2-sg"
    description = "Security group for Flask EC2 instance"
    vpc_id      = data.aws_vpc.default.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# EC2 Instance (Ubuntu 22.04)
resource "aws_key_pair" "my_key" {
    key_name = "my-key-pair" # replace with your key pair name
    public_key = file("/mnt/c/Users/NEW/.ssh/id_rsa.pub") # replace with your public key path
    
  
}
resource "aws_instance" "flask_app"{
    ami                        = "ami-09e67e426f25ce0d7" # Ubuntu 22.04 LTS in us-east-1
    instance_type               = "t2.micro"
    iam_instance_profile        = aws_iam_instance_profile.flask_instance_profile.name
    vpc_security_group_ids      = [aws_security_group.flask_sg.id]
    key_name                    = aws_key_pair.my_key.key_name
    user_data=<<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y python3-pip unzip awscli
                pip3 install flask boto3
                mkdir /home/ubuntu/flask_app
                cd /home/ubuntu/flask_app
                cat <<'PYEOT' >> app.py
                from flask import Flask, render_template_string, request
                import boto3
                import os

                app=Flask(__name__)

                S3_BUCKET = "${aws_s3_bucket.upload_bucket.bucket}"
                S3_REGION = "us-east-1"

                s3= boto3.client("s3", region_name=S3_REGION)
                HTML_FORM= '''
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Document</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                </head>
                <body class="bg-light">
                    <div class="container mt-5">
                        <div class="card shadow p-4">
                            <h3 class="text-center text-primary mb-4">Upload Image to AWS S3</h3>
                            <form action="/upload" method="post" enctype="multipart/form-data">
                                <div class="mb-3">
                                    <input type="file" name="file" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-success w-100">Upload</button> 
                            </form>
                        </div>
                    </div>
                
                    
                </body>
                </html>
                '''

                @app.route('/')
                def home():
                    return render_template_string(HTML_FORM)

                @app.route('/upload', methods=['POST'])
                def upload():
                    file=request.files['file']
                    if file:
                        s3.upload_fileobj(
                            file,
                            S3_BUCKET,
                            file.filename
                        )
                        url=f"https://{S3_BUCKET}.s3.{S3_REGION}.amazonaws.com/{file.filename}"
                        return f"File uploaded successfully! Access it <a href='{url}'>here</a>."
                if __name__ == '__main__':
                    app.run(host="0.0.0.0",port=5000)
                PYEOF

                pip install flask boto3
                nohup python3 app.py & >app.log 2>&1 &
                EOF
    tags = {
        Name = "FlaskAppInstance"
    }

}
#output bucket name
output "bucket_name" {
    value = aws_s3_bucket.upload_bucket.bucket
}