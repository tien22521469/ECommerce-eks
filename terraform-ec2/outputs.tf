output "public_ip" {
  description = "Public IP của server"
  value       = aws_instance.server.public_ip
}

output "ssh_command" {
  value = "ssh ubuntu@${aws_instance.server.public_ip}"
}