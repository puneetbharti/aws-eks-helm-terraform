variable "availability_zones" {
  description = "AZ to use"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "cidr" {
  description = "CIDR to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
  description = "CIDR used for private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets_cidr" {
  description = "CIDR used for private subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "k8s_cluster_name" {
  default = "eks-k8s-demo-dev-cluster"
}

variable "repository_name" {
  default = "eks-k8s-demo-app"
}
