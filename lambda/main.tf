resource "aws_iam_role" "lambda_service_role" {
    name = "lambda_service_role"
    assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
    managed_policy_arns = [aws_iam_policy.lambda_service_role_policy.arn]
} 

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "lambda_service_role_policy" {
  name = "policy-618033"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [           
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Scan",
            "dynamodb:UpdateItem", 
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "archive_file" "lambda_source" {
    type = "zip"
    source_file = "${path.module}/../src/index.mjs"
    output_path = "lambda_source_function.zip" 
}

resource "aws_lambda_function" "lambda" {
    filename = "lambda_soruce_function.zip"
    function_name = "handler"
    role = aws_iam_role.lambda_service_role.arn

    runtime = "nodejs20.x"
    handler = "index.handler"
}