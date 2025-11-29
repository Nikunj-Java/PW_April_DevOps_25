module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets
  enable_irsa = true

  eks_managed_node_groups = {
    dev_nodes = {
      node_group_name = var.node_group_name
      instance_types  = [var.node_instance_type]
      min_size     = var.node_min_capacity
      max_size     = var.node_max_capacity
      desired_size = var.node_desired_capacity
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
