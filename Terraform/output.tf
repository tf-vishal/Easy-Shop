output "region" {
  value = local.region
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_ip" {
  value = aws_instance.easy-shop.public_ip
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS CLUSTER API ENDPOINT"
  value = module.eks.cluster_endpoint
}

output "eks_node_group_public_ips" {
  description = "Public IPs of the EKS node group instance"
  value = data.aws_instances.eks_nodes.public_ips
}