resource "aws_lambda_function" "lambda" {

  function_name = "devops-ecr-lambda"

  package_type = "Image"

  image_uri = var.image_uri

  role = aws_iam_role.lambda_role.arn
}