data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y nginx

              cat <<'HTML' > /usr/share/nginx/html/index.html
              <html>
                <head>
                  <title>Terraform AWS Shipping Lab</title>
                </head>
                <body>
                  <h1>Hello from AWS</h1>
                  <p>This EC2 instance was provisioned with Terraform.</p>
                </body>
              </html>
              HTML

              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = {
    Name        = "terraform-shipping-lab-web"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}