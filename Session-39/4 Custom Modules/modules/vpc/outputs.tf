output "vpc_id" {
    description = "The ID of the VPC"
    value = aws_vpc.this.id
  
}

output "vpc_cidr" {
    description = "The CIDR block of the VPC"
    value = aws_vpc.this.cidr_block
  
}