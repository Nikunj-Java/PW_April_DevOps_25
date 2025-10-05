#ami-0360c520857e3138f
provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "my_ec2" {
    ami           = "ami-0360c520857e3138f"
    instance_type = "t2.micro"
    tags = {
      Name = "Terraform-Ubuntu-EC2"
    }
}

output "instance_id" {
    value = aws_instance.my_ec2.id
  
}
output "public_ip" {
    value = aws_instance.my_ec2.public_ip
}
output "private_ip" {
    value = aws_instance.my_ec2.private_ip  
  
}
output "availability_zone" {
    value = aws_instance.my_ec2.availability_zone
  
}