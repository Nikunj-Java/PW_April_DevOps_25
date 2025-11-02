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
               sudo yum update -y
               sudo amazon-linux-extras install -y java-openjdk11
               #add elastic repo
               cat <<EOT >> /etc/yum.repos.d/elastic.repo
               [elastic-7.x]
               name=Elastic repository for 7.x packages
               baseurl=https://artifacts.elastic.co/packages/7.x/yum
               gpgcheck=1
               gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
               enabled=1
               autorefresh=1
               type=rpm-md
               EOT
               sudo yum install -y logstash

               # create pipeline config file
               cat <<EOT >> /etc/logstash/conf.d/logstash.conf
               input {
                   beats {
                       port => 5044
                   }
               }
               filter {
                   stdout { codec => rubydebug }
               }
               output {
                   elasticsearch {
                       hosts => ["http://localhost:9200"]
                   }
               }
               EOT
               sudo systemctl enable logstash
               sudo systemctl start logstash
               EOF

    tags = {
        Name = "logstash-demo"
    }
  
}

output "logstash_public_ip" {
    description = "Public IP of Logstash EC2"
    value = aws_instance.logstash_server.public_ip
  
}