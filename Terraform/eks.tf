module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name = "${local.name}-eks"
  kubernetes_version = "1.33"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }


  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    easy-shop = {
        ami_type = "AL2023_x86_64_STANDARD"
        instance_types = ["c7i-flex.large"]

        min_size = 2
        max_size = 4
        desired_size = 2
    }
  }

  tags = {
    Environment = var.Environment
    Terraform = "true"
  }
}