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

  role = data.aws_iam_role.lambda_role_existing.arn

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic]
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