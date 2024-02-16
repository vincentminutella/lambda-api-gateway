resource "aws_iam_role" "lambda_service_role" {
    name = "lambda_service_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = ""
            Principal = {
              Service = "lambda.amazonaws.com"
            }
          }
        ]
      })

    managed_policy_arns = [aws_iam_policy.lambda_service_role_policy.arn]

  depends_on {
    aws_iam_policy.lambda_service_role_policy
  }
} 

resource "aws_iam_policy" "lambda_service_role_policy" {
  name = "lambda_sqs_to_dynamo_service_role"

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
        ]
        Effect   = "Allow"
        Resource = "${var.table_arn}"
      },
      {
        Action   = [           
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = [           
            "sqs:GetQueueAttributes",
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage"
        ]
        Effect   = "Allow"
        Resource = "${var.sqs_arn}"
      }
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

resource "aws_lambda_event_source_mapping" "sqs" {
  event_source_arn = var.sqs_arn
  function_name    = aws_lambda_function.lambda.arn
}