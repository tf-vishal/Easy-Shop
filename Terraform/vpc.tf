
locals {
  name = "easy-shop"
  cidr = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24","10.0.102.0/24"]

  
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name}-vpc"
  cidr = local.cidr

  azs = local.azs
  private_subnets = local.private_subnets
  public_subnets = local.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}-eks" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}-eks" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  tags = {
    Terraform = "true"
    Name = "${local.name}"
    Environment = var.Environment
    
  }
}