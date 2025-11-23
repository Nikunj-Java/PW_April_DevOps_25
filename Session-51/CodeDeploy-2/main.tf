provider "aws" {
  region = "ap-south-1"
}

# -------------------------------
# VPC & SUBNETS
# -------------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# -------------------------------
# S3 BUCKET FOR CODEDEPLOY ARTIFACTS
# -------------------------------
resource "aws_s3_bucket" "codedeploy_bucket" {
  bucket        = "my-codedeploy-demo-bucket-nikunj"
  force_destroy = true
}

# -------------------------------
# IAM ROLE FOR EC2 (S3 + CodeDeploy Agent)
# -------------------------------
resource "aws_iam_role" "ec2_role" {
  name = "EC2CodeDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_codedeploy_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2CodeDeployProfile"
  role = aws_iam_role.ec2_role.name
}

# -------------------------------
# SECURITY GROUP
# -------------------------------
resource "aws_security_group" "web_sg" {
  name   = "web-sg-nikunj"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
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

# -------------------------------
# EC2 INSTANCE
# -------------------------------
resource "aws_instance" "webserver" {
  ami                    = "ami-0d176f79571d18a8f" # Amazon Linux 2023
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = file("userdata.sh")

  tags = {
    Name = "MyAppServer"
    Env  = "Dev"
  }
}

# -------------------------------
# IAM ROLE FOR CODEDEPLOY SERVICE
# -------------------------------
resource "aws_iam_role" "codedeploy_service_role" {
  name = "CodeDeployServiceRole1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codedeploy.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_service_policy" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# -------------------------------
# CODEDEPLOY APPLICATION
# -------------------------------
resource "aws_codedeploy_app" "webapp" {
  name             = "MyWebApp1"
  compute_platform = "Server"
}

# -------------------------------
# DEPLOYMENT GROUP
# -------------------------------
resource "aws_codedeploy_deployment_group" "group" {
  app_name              = aws_codedeploy_app.webapp.name
  deployment_group_name = "MyWebAppDG"
  service_role_arn      = aws_iam_role.codedeploy_service_role.arn

  deployment_config_name = "CodeDeployDefault.OneAtATime"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Env"
      value = "Dev"
      type  = "KEY_AND_VALUE"
    }
  }
}

