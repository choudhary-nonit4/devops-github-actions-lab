provider "aws" {
  region = "us-east-1"
}

# ---------------------------
# Security Group
# ---------------------------
resource "aws_security_group" "app_sg" {
  name        = "node-app-sg"
  description = "Allow Node app traffic"

  ingress {
    description = "Allow HTTP app traffic"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH (restrict later)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# EC2 Instance
# ---------------------------
resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"  # ✅ updated

  key_name = "docker-ec2"

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -aG docker ec2-user

              docker pull ${var.image_uri}
              docker run -d -p 3000:3000 ${var.image_uri}
              EOF

  user_data_replace_on_change = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "node-app"
  }
}

# ---------------------------
# Output Public IP
# ---------------------------
output "public_ip" {
  value = aws_instance.app.public_ip
}