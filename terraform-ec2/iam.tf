# 1. Tạo Role
resource "aws_iam_role" "ec2_role" {
  name = "${var.instance_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# 2. Gán quyền (Policy) cho Role
# Ví dụ: Gán quyền AdministratorAccess để bạn thoải mái test (Cẩn thận khi dùng Prod)
resource "aws_iam_role_policy_attachment" "ec2_admin_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 3. Tạo Instance Profile (Cầu nối để gắn Role vào EC2)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.instance_name}-profile"
  role = aws_iam_role.ec2_role.name
}