terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group for SSH + HTTP
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # For testing only, restrict in production
  }

  ingress {
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
}

# EC2 instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "ProvisionerDemo"
  }
}

# Provisioning with remote-exec
resource "null_resource" "bootstrap" {
  depends_on = [aws_instance.web]

  triggers = {
    instance_id = aws_instance.web.id
    script_hash = filemd5("scripts/setup.sh")
  }

  provisioner "file" {
    source      = "scripts/setup.sh"
    destination = "/tmp/setup.sh"

    connection {
      type        = "ssh"
      host        = aws_instance.web.public_ip
      user        = "ec2-user"
      private_key = file(var.ssh_private_key_path)
      timeout     = "4m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo bash /tmp/setup.sh"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.web.public_ip
      user        = "ec2-user"
      private_key = file(var.ssh_private_key_path)
      timeout     = "4m"
    }
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
