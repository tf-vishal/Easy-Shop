output "vpc_id" {
  value = module.vpc.vpc_id
}

output "region" {
  description = "The AWS region where the resources are created:"
  value = var.region
}

output "eks_cluster_name" {
  description = "EKS cluster Name"
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value = module.eks.cluster_endpoint
}

output "eks_node_group_public_ips" {
  description = "Public Ips of the EKS ndoe group instance"
  value = data.aws_instances.eks_nodes.public_ips
}