provider "aws" {
  region = "eu-central-1"
}

module "eks-k8s-demo-dev-cluster" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = var.k8s_cluster_name
  subnets      = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id

  worker_groups = [
    {
      instance_type = "t2.small"
      asg_desired_capacity = 3
      asg_min_size  = 2
      asg_max_size  = 5
      tags = [{
        key                 = "Name"
        value               = "eks-k8s-demo-worker"
        propagate_at_launch = true
      }]
    }
  ]

  tags = {
    environment = "dev"
  }
}

resource "aws_ecr_repository" "eks-k8s-demo-app" {
  name = "eks-k8s-demo-app"
}

resource "aws_ecr_repository_policy" "eks-k8s-demo-app-policy" {
  repository = "${aws_ecr_repository.eks-k8s-demo-app.name}"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}