data "aws_iam_role" "lambda_role_existing" {
  name = "lambda-execution-role"
}

resource "aws_lambda_function" "lambda" {

  function_name = "devops-ecr-lambda"

  package_type = "Image"

  image_uri = var.image_uri

  role = try(data.aws_iam_role.lambda_role_existing.arn, aws_iam_role.lambda_role[0].arn)

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [aws_iam_role.lambda_role]
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic]
}

resource "aws_iam_role" "lambda_role" {
  count = try(data.aws_iam_role.lambda_role_existing.id, null) != null ? 0 : 1

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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {

  role       = try(data.aws_iam_role.lambda_role_existing.name, aws_iam_role.lambda_role[0].name)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

  lifecycle {
    create_before_destroy = true
  }
}