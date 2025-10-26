terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ---------------------------
# Variables (quick edit)
# ---------------------------
variable "key_name" {
  description = "Existing EC2 Key Pair name in AWS (required for SSH)"
  type        = string
  default     = "test" # <-- REPLACE this before apply
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# ---------------------------
# Availability Zones
# ---------------------------
data "aws_availability_zones" "available" {}

# ---------------------------
# VPC, IGW, Route Table
# ---------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "alb-app-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "alb-app-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "alb-app-public-rt" }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# ---------------------------
# Two public subnets (different AZs)
# ---------------------------
resource "aws_subnet" "a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = { Name = "alb-app-subnet-a" }
}

resource "aws_subnet" "b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = { Name = "alb-app-subnet-b" }
}

resource "aws_route_table_association" "a_assoc" {
  subnet_id      = aws_subnet.a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "b_assoc" {
  subnet_id      = aws_subnet.b.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------
# Security Groups
# ---------------------------
# ALB SG: allow HTTP from internet
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from Internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 SG: allow traffic only from ALB SG to app port 3000; allow SSH (optionally restrict to your IP)
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "EC2 SG for Express app"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "Allow SSH for maintenance"
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

  tags = {
    Name = "ec2-sg"
  }
}

# ---------------------------
# ALB + Target Group + Listener
# ---------------------------
resource "aws_lb" "alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.a.id, aws_subnet.b.id]
  tags               = { Name = "app-alb" }
}

resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = { Name = "app-tg" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# ---------------------------
# EC2 Instances with user_data (Node/Express app)
# ---------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# common user_data that installs Node, writes app.js and systemd service
locals {
  user_data = <<-EOF
    #!/bin/bash
    set -e

    # install nodejs and git
    curl -sL https://rpm.nodesource.com/setup_18.x | bash -
    yum install -y nodejs

    # create app
    mkdir -p /opt/simple-express
    cat > /opt/simple-express/app.js <<'APP'
    const express = require('express');
    const os = require('os');
    const app = express();
    const PORT = 3000;
    app.get('/', (req, res) => {
      const hostname = os.hostname();
      res.send(`<html><body><h1>Hello from $${hostname}</h1><p>Served by instance: <strong>$${hostname}</strong></p></body></html>`);
    });
    app.get('/health', (req, res) => res.status(200).send('OK'));
    app.listen(PORT, () => console.log('Listening on', PORT));
    APP

    cd /opt/simple-express
    npm init -y
    npm install express

    # create systemd service
    cat > /etc/systemd/system/simple-express.service <<'SERVICE'
    [Unit]
    Description=Simple Express App
    After=network.target

    [Service]
    ExecStart=/usr/bin/node /opt/simple-express/app.js
    Restart=always
    User=root
    Environment=NODE_ENV=production

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable simple-express
    systemctl start simple-express
  EOF
}

resource "aws_instance" "app" {
  count                   = 2
  ami                     = data.aws_ami.amazon_linux.id
  instance_type           = var.instance_type
  subnet_id               = element([aws_subnet.a.id, aws_subnet.b.id], count.index)
  vpc_security_group_ids  = [aws_security_group.ec2_sg.id]
  key_name                = var.key_name
  user_data               = local.user_data
  tags = {
    Name = "app-instance-${count.index}"
  }
}

# attach instances into target group
resource "aws_lb_target_group_attachment" "app_attach" {
  count            = 2
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app[count.index].id
  port             = 3000
}

# ---------------------------
# Outputs
# ---------------------------
output "alb_dns" {
  value = aws_lb.alb.dns_name
}

output "app_instance_public_ips" {
  value = [for i in aws_instance.app : i.public_ip]
}
