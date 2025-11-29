variable "region" {
  description = "AWS Region"
  default     = "ap-southeast-1"
}

variable "instance_name" {
  description = "Tên đặt cho EC2"
  default     = "k8s-server"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.medium" # t3.medium (2vCPU, 4GB RAM) tốt cho lab k8s
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}