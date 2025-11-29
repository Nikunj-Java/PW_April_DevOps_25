variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "dev-cluster"
}

variable "node_group_name" {
  type    = string
  default = "dev-nodes"
}

variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "node_desired_capacity" {
  type    = number
  default = 2
}

variable "node_min_capacity" {
  type    = number
  default = 2
}

variable "node_max_capacity" {
  type    = number
  default = 5
}

variable "create_iam_user" {
  type    = bool
  default = true
}

variable "iam_user_name" {
  type    = string
  default = "eks-admin-user"
}
