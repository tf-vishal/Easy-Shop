variable "aws_region" {
    description = "AWS region where resources will be provisioned"
    default = "us-east-1"
}

variable "ami_id" {
    description = "AMI ID for EC2 INSTANCE"
    default = "ami-0ecb62995f68bb549"
}

variable "instance_type" {
    description = "Instance Type for the EC2 INSTANCE"
    default = "t2.medium"
}

variable "my_environment" {
  description = "Instance type for the EC2 Instance"
  default = "dev"
}

locals {
  region = "us-east-1"
  name = "EKS_CLUSTER_DEMO"
  vpc_cidr = "10.0.0.0/16"
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  infra_subnets = ["10.0.5.0/24", "10.0.6.0/24"]

  tags = {
    example = local.name
  }
}

