provider "aws" {
  region = "ap-southeast-1" 
}

locals {
  services = [
    "database",
    "product-service",
    "frontend",
    "user-service",
  ]
}

resource "aws_ecr_repository" "services" {
  for_each = toset(local.services)

  name = each.value

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

 
  force_delete = true

  tags = {
    Environment = "production"
    Service     = each.value
  }
}