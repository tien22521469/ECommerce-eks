module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.instance_name}-vpc"
  cidr = var.vpc_cidr

  azs            = ["${var.region}a"]
  public_subnets = ["10.0.1.0/24"]

  # Bật các tùy chọn DNS để node mạng hoạt động ổn định
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tự động gán Public IP cho máy nằm trong subnet này
  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}