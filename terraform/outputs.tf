output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "rds_username" {
  value = aws_db_instance.rds.username
}

output "rds_password" {
  value     = var.db_password
  sensitive = true
}