provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  key_name = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -aG docker ec2-user

              docker pull ${var.image_uri}
              docker run -d -p 3000:3000 ${var.image_uri}
              EOF

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "node-app"
  }
}