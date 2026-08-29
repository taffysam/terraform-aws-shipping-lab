output "vpc_id" {
  description = "ID of the lab VPC"
  value       = aws_vpc.lab.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_a.id
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IPv4 address of the web instance"
  value       = aws_instance.web.public_ip
}

output "website_url" {
  description = "URL of the lab web application"
  value       = "http://${aws_instance.web.public_ip}"
}