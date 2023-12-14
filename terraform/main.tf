resource "aws_ecr_repository" "base" {
	name                 = var.proj_name
	image_tag_mutability = "MUTABLE"
	force_delete         = true
}

module "vpc" {
	source  = "terraform-aws-modules/vpc/aws"
	version = "5.4.0"

	name = "${var.proj_name}-${var.proj_env}-vpc"

	cidr = "10.0.0.0/16"
	azs  = ["eu-central-1a", "eu-central-1b"]

	private_subnets = ["10.0.0.0/20", "10.0.16.0/20"]
	public_subnets  = ["10.0.128.0/20", "10.0.144.0/20"]

	enable_nat_gateway   = true
	single_nat_gateway   = true
	enable_dns_hostnames = true

	public_subnet_tags = {
		"kubernetes.io/cluster/${var.proj_name}-${var.proj_env}" = "shared"
		"kubernetes.io/role/elb"                                 = 1
	}

	private_subnet_tags = {
		"kubernetes.io/cluster/${var.proj_name}-${var.proj_env}" = "shared"
		"kubernetes.io/role/internal-elb"                        = 1
	}
}

module "eks" {
	source  = "terraform-aws-modules/eks/aws"
	version = "19.21.0"

	cluster_name    = "${var.proj_name}-${var.proj_env}"
	cluster_version = "1.27"

	vpc_id                         = module.vpc.vpc_id
	subnet_ids                     = module.vpc.private_subnets
	cluster_endpoint_public_access = true

	eks_managed_node_group_defaults = {
		instance_type = var.default_instance_type
	}

	eks_managed_node_groups = {
		one = {
			name            = "node-group-1"
			capacity_type   = "SPOT"
			min_size        = 0
			max_size        = 2
			desired_size    = 1
		}
	}
}

