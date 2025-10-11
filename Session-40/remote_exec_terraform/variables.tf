variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Name of your AWS key pair"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to your private key (.pem) file"
  type        = string
}
