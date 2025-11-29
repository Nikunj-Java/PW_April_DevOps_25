output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Cluster CA data (base64)"
  value       = module.eks.cluster_certificate_authority_data
}

output "kubeconfig_command" {
  description = "Command to update kubeconfig (if needed)"
  value       = "aws eks --region ${var.aws_region} update-kubeconfig --name ${var.cluster_name}"
}
