output "vpc_id" {
  description = "ID of the VPC created by Terraform"
  value       = module.vpc.vpc_id
}

output "k8s_cluster_name" {
  description = "Name of the EKS cluster created by Terraform"
  value       = module.eks.cluster_name
}
