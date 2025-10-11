terraform {
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~>5.0"
    }
  }
}
provider "aws" {
    region = var.aws_region
}
data "aws_ami" "amazon_linux"{
    most_recent = true
    owners      = ["amazon"]
    filter{
        name    = "name"
        values  = ["amzn2-ami-hvm-*-x86_64-gp2"]

    }
}
resource "aws_security_group" "web_sg" {
    name        ="web-sg"
    description = "Allow SSH and HTTP"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
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
resource "aws_instance" "web_remote" {
    ami             = data.aws_ami.amazon_linux.id
    instance_type   = var.instance_type
    key_name        =var.key_name

     
  tags = {
    Name        =" web-${terraform.workspace}"
  }
}

#Null resource to execute remote commands
resource "null_resource" "bootstrap" {
    depends_on = [ aws_instance.web_remote ]

    #triggers: return provisioning when these changes
    triggers ={
        instance_id= aws_instance.web_remote.id
        script_hash= filemd5("scripts/setup.sh")
    }

    #copy the setup script to remote instance
    provisioner "file" {
        source = "scripts/setup.sh"
        destination = "/tmp/setup.sh"

        connection {
            host = aws_instance.web_remote.public_ip
            user = "ec2-user"         
        }
      
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/setup.sh",
            "sudo bash /tmp/setup.sh"
         ]

         connection {
            host = aws_instance.web_remote.public_ip
            user = "ec2-user" 
         }
      
    }
  
}

output "public_ip" {
    value = aws_instance.web_remote.public_ip
}