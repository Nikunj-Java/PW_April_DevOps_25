provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = "elk-key"
  public_key = file("/mnt/c/Users/NEW/.ssh/id_rsa.pub")
}

resource "aws_security_group" "elk_sg" {
  name_prefix = "elk-sg"
  description = "Security group for ELK stack"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5044
    to_port     = 5044
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

resource "aws_instance" "elk" {
  ami                    = "ami-0f58b397bc5c1f2e8" # ✅ Mumbai region (Ubuntu 22.04)
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.elk_sg.id]
  user_data              = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "ELK-Instance"
  }
}

output "elk_instance_ip" {
  description = "Public IP of the ELK server"
  value       = aws_instance.elk.public_ip
}
