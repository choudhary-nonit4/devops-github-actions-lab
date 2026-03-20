variable "region" {
  default = "us-east-1"
}

variable "image_uri" {
  description = "Docker image URI"
}

variable "db_name" {
  default = "mydb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  description = "RDS master password"
  sensitive   = true
}

variable "allowed_ip" {
  description = "Your IP to allow access"
}