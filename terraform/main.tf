data "aws_iam_role" "lambda_role_existing" {
  name = "lambda-execution-role"
}

resource "aws_lambda_function" "lambda" {

  function_name = "devops-ecr-lambda"

  package_type = "Image"

  image_uri = var.image_uri

  role = data.aws_iam_role.lambda_role_existing.arn

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic]
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {

  role       = data.aws_iam_role.lambda_role_existing.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

  lifecycle {
    create_before_destroy = true
  }
}