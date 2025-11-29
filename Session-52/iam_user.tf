resource "aws_iam_user" "eks_admin" {
  count = var.create_iam_user ? 1 : 0
  name  = var.iam_user_name
  tags = {
    Terraform = "true"
    Role      = "eks-admin"
  }
}

# Attach the managed policies that were listed by the user
locals {
  managed_policies = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/IAMUserChangePassword"
  ]
}

resource "aws_iam_user_policy_attachment" "eks_admin_attachments" {
  count      = var.create_iam_user ? length(local.managed_policies) : 0
  user       = aws_iam_user.eks_admin[0].name
  policy_arn = local.managed_policies[count.index]
}
