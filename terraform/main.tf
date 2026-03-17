# Check if the IAM role already exists
data "aws_iam_roles" "existing_roles" {}

locals {
  role_exists = contains([for role in data.aws_iam_roles.existing_roles.arns : split("/", role)[1]], "lambda-execution-role")
  role_arn    = local.role_exists ? [for arn in data.aws_iam_roles.existing_roles.arns : arn if contains(arn, "lambda-execution-role")][0] : aws_iam_role.lambda_role[0].arn
  role_name   = local.role_exists ? "lambda-execution-role" : aws_iam_role.lambda_role[0].name
}

resource "aws_lambda_function" "lambda" {
  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic
  ]

  function_name = "devops-ecr-lambda"

  package_type = "Image"

  image_uri = var.image_uri

  role = local.role_arn
}

resource "aws_iam_role" "lambda_role" {
  count = local.role_exists ? 0 : 1

  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {

  role       = local.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}