provider "aws" {
    region = var.aws_region
}
module "my_vpc" {
    source = "./modules/vpc"
    cidr_block = var.cidr_blocks[0]
    vpc_name = "Terraform-Module-VPC"
}

output "vpc_id" {
    value = module.my_vpc.vpc_id
}

output "vpc_cidr" {
    value = module.my_vpc.vpc_cidr  
}