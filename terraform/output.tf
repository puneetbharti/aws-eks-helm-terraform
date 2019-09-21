output "vpc_public_ips" {
  value = module.vpc.nat_public_ips
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "registry_id" {
  description = "The account ID of the registry holding the repository."
  value = "${aws_ecr_repository.eks-k8s-demo-app.registry_id}"
}
output "repository_url" {
  description = "The URL of the repository."
  value = "${aws_ecr_repository.eks-k8s-demo-app.repository_url}"
}

