provider "aws" {
  region = var.region
}

# --- 1. TẠO VPC CHUẨN CHO EKS ---
# EKS yêu cầu cấu trúc mạng kỹ lưỡng (Tags cho Load Balancer, NAT Gateway...)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # Tiết kiệm chi phí (chỉ dùng 1 NAT cho dev)
  enable_vpn_gateway = false

  # Tags bắt buộc để EKS Load Balancer hoạt động
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

# --- 2. TẠO EKS CLUSTER ---
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Cho phép truy cập Cluster từ Internet (để bạn chạy kubectl từ máy tính cá nhân)
  cluster_endpoint_public_access = true

  # Kết nối mạng từ module VPC bên trên
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Cấu hình Node Group (Máy Worker)
  eks_managed_node_groups = {
    main = {
      min_size     = 1
      max_size     = 3
      desired_size = var.node_desired_size

      instance_types = var.node_instance_type
      capacity_type  = "ON_DEMAND"
    }
  }

  # Cấp quyền Admin cho user đang chạy Terraform
  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}