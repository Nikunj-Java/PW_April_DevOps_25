############################################################
# Provider
############################################################
terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = var.aws_region
}

############################################################
# Variables
############################################################
variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  default = ""  # Set your AWS key pair name here
}

variable "existing_vpc_id" {
  default = ""
}

variable "existing_public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "instance_type" {
  default = "t2.micro"
}

variable "tags" {
  default = {}
}

############################################################
# Availability Zones
############################################################
data "aws_availability_zones" "available" {}

############################################################
# Create VPC if not existing
############################################################
resource "aws_vpc" "this" {
  count               = var.existing_vpc_id == "" ? 1 : 0
  cidr_block          = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags                = merge(var.tags, { Name = "elb-demo-vpc" })
}

############################################################
# Create two public subnets in different AZs
############################################################
resource "aws_subnet" "public_a" {
  vpc_id                  = var.existing_vpc_id != "" ? var.existing_vpc_id : aws_vpc.this[0].id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "elb-demo-public-a" })
}

resource "aws_subnet" "public_b" {
  vpc_id                  = var.existing_vpc_id != "" ? var.existing_vpc_id : aws_vpc.this[0].id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "elb-demo-public-b" })
}

############################################################
# Internet Gateway
############################################################
resource "aws_internet_gateway" "igw" {
  count  = var.existing_vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.this[0].id
  tags   = merge(var.tags, { Name = "elb-demo-igw" })
}

############################################################
# Route Table
############################################################
resource "aws_route_table" "public_rt" {
  count  = var.existing_vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.this[0].id
  tags   = merge(var.tags, { Name = "elb-demo-public-rt" })
}

resource "aws_route" "default_route" {
  count                  = var.existing_vpc_id == "" ? 1 : 0
  route_table_id         = aws_route_table.public_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = var.existing_vpc_id != "" ? null : aws_route_table.public_rt[0].id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = var.existing_vpc_id != "" ? null : aws_route_table.public_rt[0].id
}

############################################################
# Local VPC and Subnets
############################################################
locals {
  vpc_id  = var.existing_vpc_id != "" ? var.existing_vpc_id : aws_vpc.this[0].id
  subnets = length(var.existing_public_subnet_ids) >= 2 ? var.existing_public_subnet_ids : [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

############################################################
# Security Groups
############################################################
resource "aws_security_group" "alb_sg" {
  name   = "elb-demo-alb-sg"
  vpc_id = local.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "ec2_sg" {
  name   = "elb-demo-ec2-sg"
  vpc_id = local.vpc_id

  ingress {
    description     = "From ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "SSH"
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

  tags = var.tags
}

############################################################
# ALB
############################################################
resource "aws_lb" "alb" {
  name               = "elb-demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.subnets
  enable_deletion_protection = false
  tags = var.tags
}

############################################################
# Target Group
############################################################
resource "aws_lb_target_group" "tg" {
  name     = "elb-demo-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = var.tags
}

############################################################
# Listener
############################################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

############################################################
# Simple EC2 Instance
############################################################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = local.subnets[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = length(var.key_name) > 0 ? var.key_name : null
  tags                   = merge(var.tags, { Name = "elb-demo-app" })

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd socat
    echo "<html><body><h1>ELB Demo OK</h1></body></html>" > /var/www/html/index.html
    systemctl enable httpd
    systemctl start httpd
    nohup socat TCP-LISTEN:8080,fork TCP:127.0.0.1:80 &
  EOF
}

############################################################
# Register EC2 with Target Group
############################################################
resource "aws_lb_target_group_attachment" "app_attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.app.id
  port             = 8080
}

############################################################
# Outputs
############################################################
output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "ALB DNS name"
}

output "ec2_public_ip" {
  value       = aws_instance.app.public_ip
  description = "Public IP of EC2 instance"
}
