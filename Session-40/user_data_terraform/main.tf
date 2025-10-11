terraform {
  required_providers {
    aws={source = "hashicorp/aws"}
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
resource "aws_instance" "web_userdata" {
    ami             = data.aws_ami.amazon_linux.id
    instance_type   = var.instance_type
    key_name        =var.key_name

    user_data = <<-EOF
        #!/bin/bash
        if [! -f /etc/web_init_done]; then
            yum update -y
            yum install -y nginx
            systemctl enable nginx
            systemctl start nginx
            touch /etc/web_init_done
        fi
    EOF
  tags = {
    Name        =" web-${terraform.workspace}"
  }
}