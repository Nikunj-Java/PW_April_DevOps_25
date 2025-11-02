provider "aws" {
    region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
    key_name   = "mylogstash-key"
    public_key = file("/mnt/c/Users/NEW/.ssh/id_rsa.pub")
}

resource "aws_security_group" "logstash_sg" {
    name        = "logstash_sg"
    description = "Allow SSH and Logstash ports"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
        from_port   = 5044
        to_port     = 5044
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
        from_port   = 5601
        to_port     = 5601
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

resource "aws_instance" "logstash_server" {
    ami                    = var.ami_id 
    instance_type          = var.instance_type
    key_name               = aws_key_pair.deployer.key_name
    security_groups        = [aws_security_group.logstash_sg.name]

   #user_data              = file("setup_logstash.sh")
   user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update packages
              sudo apt-get update -y
              sudo apt update
              sudo apt install fontconfig openjdk-21-jre

              # Add Jenkins key and repo (new method)
              sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

              echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

              # Update and install Jenkins
              sudo apt update
              sudo apt install jenkins

              # Enable and start Jenkins
              sudo systemctl daemon-reload
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
            EOF
 #sudo cat /var/lib/jenkins/secrets/initialAdminPassword

    tags = {
        Name = "logstash-demo"
    }
  
}

output "logstash_public_ip" {
    description = "Public IP of Logstash EC2"
    value = aws_instance.logstash_server.public_ip
  
}