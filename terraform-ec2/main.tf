provider "aws" {
  region = var.region
}

# 1. Tìm AMI Amazon Linux 2023 (Quan trọng: Đã sửa từ Ubuntu sang AL2023)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 2. Security Group (Giữ nguyên, đảm bảo mở port cần thiết)
resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow SSH, Jenkins, SonarQube"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Port Jenkins
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Port SonarQube
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Tạo EC2 Instance
resource "aws_instance" "server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.large" # Khuyên dùng: t3.medium hoặc t3.large vì cài rất nhiều tool (Jenkins + Sonar rất nặng)
  
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  # Tăng dung lượng ổ cứng vì Docker Images và Jenkins tốn chỗ
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    # Ghi log quá trình cài đặt ra file để debug
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    
    echo "--- START SETUP ---"
    
    # Chuyển về thư mục của user mặc định
    cd /home/ec2-user

    # Tạo file script từ nội dung bạn cung cấp
    cat <<'EOT' > ./install-tools.sh
    ${file("${path.module}/install-tools.sh")}
    EOT
    
    # Cấp quyền và chạy
    chmod +x ./install-tools.sh
    ./install-tools.sh

    echo "--- FINISH SETUP ---"
  EOF

  tags = {
    Name = "DevOps-Tool-Server"
  }
}