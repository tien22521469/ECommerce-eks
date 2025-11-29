variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1" # Singapore
}

variable "cluster_name" {
  description = "Tên của EKS Cluster"
  type        = string
  default     = "my-demo-cluster"
}

variable "cluster_version" {
  description = "Phiên bản Kubernetes"
  type        = string
  default     = "1.30" 
}

variable "vpc_cidr" {
  description = "Dải IP cho VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_instance_type" {
  description = "Loại EC2 instance cho Worker Nodes"
  type        = list(string)
  default     = ["t3.medium"] # t3.medium là tối thiểu để chạy ổn định
}

variable "node_desired_size" {
  description = "Số lượng Node mong muốn"
  type        = number
  default     = 2
}