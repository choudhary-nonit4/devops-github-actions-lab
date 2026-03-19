provider "aws" {
  region = var.region
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group
resource "aws_security_group" "rds_sg" {
  name        = "rds-public-sg"
  description = "Allow DB access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow DB access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

<<<<<<< HEAD
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Subnet group
resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  lifecycle {
    create_before_destroy = true
  }
=======
  role = data.aws_iam_role.lambda_role_existing.arn

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic]
>>>>>>> 7e600c4d3b565a31637e2bd97144f7e60896090a
}

# RDS Instance
resource "aws_db_instance" "rds" {
  identifier              = "my-rds-instance"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password

  publicly_accessible     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.default.name

  skip_final_snapshot     = true

  role       = data.aws_iam_role.lambda_role_existing.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

  lifecycle {
    create_before_destroy = true
  }
}