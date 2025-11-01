provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployer" {

    key_name   = "elk-key"
    public_key = file("/mnt/c/Users/NEW/.ssh/id_rsa.pub") #your path
    
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
        from_port   = 9200
        to_port     = 9200
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

resource "aws_instance" "elk" {
    ami = "ami-0ecb62995f68bb549" #Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    user_data = file("${path.module}/user_data.sh")
    vpc_security_group_ids = [ aws_security_group.elk_sg.id ]
    root_block_device {
      volume_size = 30
      volume_type = "gp2"
    }
    tags = {
      Name = "ELK-Instance"
    }
}