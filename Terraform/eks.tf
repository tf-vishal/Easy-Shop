module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name = local.name
  kubernetes_version = "1.33"

  addons = {
    coredns = {
        most_recent = true
    }
    kube-proxy = {
        most_recent = true
    }
    vpc-cni = {
        most_recent = true
    }
  }

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_groups = {

    Easy-Shop-ng = {
        instance_types = ["t2.medium"]
        attach_cluster_primary_security_group = true

        min_size = 2
        max_size = 3
        desired_size = 2

        

        disk_size = 35
        use_custom_launch_template = false 

        tags = {
            Name = "Easy-Shop-ng"
            Environment = "dev"
            Extratag = "E-Comm-App"
        }
    }
  }

  tags = local.tags
  
}

data "aws_instances" "eks_nodes" {
    instance_tags =   {
        "eks:cluster-name" = module.eks.cluster_name
    }
    filter {
      name = "instance-state-name"
      values = ["running"]
    }

    depends_on = [ module.eks ]
}