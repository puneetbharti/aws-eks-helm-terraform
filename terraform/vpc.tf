module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-k8s-demo-coding-challenge-vpc"
  cidr = var.cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Context = "coding-challenge"
    "kubernetes.io/cluster/${var.k8s_cluster_name}" = "shared"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.k8s_cluster_name}" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.k8s_cluster_name}" = "shared"
  }
}
