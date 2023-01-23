data "aws_availability_zones" "available" {}

resource "aws_key_pair" "key_pair" {
  key_name = var.cluster_name
  public_key = file(var.key_pair_path["public_key_path"])
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.19"
  subnets         = module.vpc.private_subnets

  tags = {
    "tigera.fr/environment"                 = var.cluster_name
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-linux"
      instance_type                 = "t3.xlarge"
      key_name                      = var.cluster_name
      asg_desired_capacity          = 2
      asg_max_size                  = 4
      root_volume_size              = 30
      root_volume_type              = "gp2"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      tags                          = [
        {
          key                 = "tigera.fr/environment"
          value               = var.cluster_name
          propagate_at_launch = "true"
        }
      ]
    }
  ]
  workers_additional_policies = [aws_iam_policy.worker_policy.arn]
}

resource "aws_iam_policy" "worker_policy" {
  name        = "eks-worker-loadbalancer-policy"
  description = "EKS worker policy for Loadbalancers"

  policy = file("iam-policy.json")
}

resource "aws_security_group" "bastion" {
  name   = "${var.cluster_name}-bastion-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["50.64.0.0/13", "75.157.120.0/22"]
    from_port   = 22
    to_port     = 22
  }
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

module "bastion" {
  source = "./bastion"

  source_subnet            = var.source_subnet
  instance_type            = var.aws_bastion_instance_type
  cluster_id               = var.cluster_name
  ssh_key                  = var.key_pair_path["public_key_path"]
  subnet_id                = module.vpc.public_subnets[0]
  vpc_id                   = module.vpc.vpc_id
  vpc_cidrs                = [module.vpc.vpc_cidr_block]
  vpc_security_group_ids   = [aws_security_group.bastion.id]
  tags                     = { "tigera.fr/environment" = var.cluster_name,
                               "tigera.fr/role"        = "bastion"
                             }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
