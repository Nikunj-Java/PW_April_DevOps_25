

provider "aws" {
  region = "us-east-1"
}

# Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "gf-key"
  public_key = file("/mnt/c/Users/NEW/.ssh/id_rsa.pub")
}

# Security Group
resource "aws_security_group" "grafana_sg" {
  name_prefix = "grafana-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9100
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

# Zip up the entire directory (excluding .terraform)
data "archive_file" "monitoring_zip" {
  type        = "zip"
  source_dir  = "${path.module}"
  output_path = "${path.module}/bundle.zip"
  excludes    = [".terraform", "bundle.zip"]
}

# EC2 Instance
resource "aws_instance" "grafana_host" {
  ami                    = "ami-0bdd88bd06d16ba03" # Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.grafana_sg.id]

  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y docker unzip
  systemctl enable docker
  systemctl start docker
  curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  EOF


  provisioner "file" {
    source      = "${path.module}/bundle.zip"
    destination = "/home/ec2-user/bundle.zip"
  }

  provisioner "remote-exec" {
  inline = [
    # Wait for Docker Compose to become available (max 60s)
    "for i in {1..12}; do if [ -f /usr/local/bin/docker-compose ]; then break; else echo 'Waiting for docker-compose...'; sleep 5; fi; done",

    # Unzip uploaded bundle
    "unzip /home/ec2-user/bundle.zip -d /home/ec2-user/monitoring",

    # Go to the directory and run Docker Compose
    "cd /home/ec2-user/monitoring",
    "sudo /usr/local/bin/docker-compose up -d"
  ]

}

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/mnt/c/Users/NEW/.ssh/id_rsa")
    host        = self.public_ip
  }

  tags = {
    Name = "grafana-monitor"
  }

  depends_on = [aws_key_pair.deployer]
}

# Output
output "grafana_url" {
  value = "http://${aws_instance.grafana_host.public_ip}:3000"
}

output "prometheus_url" {
  value = "http://${aws_instance.grafana_host.public_ip}:9090"
}

