resource "aws_api_gateway_rest_api" "api" {

  name          = "rest-api"
  description   = "REST API Gateway to SQS"
  protocol_type = "HTTP"

  domain_name = var.domain_name_arn

}

resource "aws_api_gateway_request_validator" "api" {
  rest_api_id           = "${aws_api_gateway_rest_api.api.id}"
  name                  = "payload-validator"
  validate_request_body = true
}

resource "aws_api_gateway_model" "api" {
  rest_api_id  = "${aws_api_gateway_rest_api.api.id}"
  name         = "PayloadValidator"
  description  = "validate the json body content conforms to the below spec"
  content_type = "application/json"

  schema = <<EOF
  {
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "required": [ "id", "date", "text"],
    "properties": {
    "id": { "type": "string" },
    "date": { "type": "string },
    "text": { "type": "string }
    }
  }
  EOF
}

resource "aws_api_gateway_method" "api" {
  rest_api_id          = "${aws_api_gateway_rest_api.api.id}"
  resource_id          = "${aws_api_gateway_rest_api.api.root_resource_id}"
  api_key_required     = false
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = "${aws_api_gateway_request_validator.api.id}"

  request_models = {
    "application/json" = "${aws_api_gateway_model.api.name}"
  }
}

resource "aws_api_gateway_integration_response" "200" {
  rest_api_id       = "${aws_api_gateway_rest_api.api.id}"
  resource_id       = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method       = "${aws_api_gateway_method.api.http_method}"
  status_code       = "${aws_api_gateway_method_response.200.status_code}"
  selection_pattern = "^2[0-9][0-9]" // regex pattern for any 200 message that comes back from SQS

  response_templates = {
    "application/json" = "{\"message\": \"post to sqs successful!\"}"
  }

  depends_on = ["aws_api_gateway_integration.api"]
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method = "${aws_api_gateway_method.api.http_method}"
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "main"

  depends_on = [
    "aws_api_gateway_integration.api",
  ]
}

resource "aws_api_gateway_integration" "api" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method             = "POST"
  type                    = "AWS"
  integration_http_method = "POST"
  passthrough_behavior    = "NEVER"
  credentials             = "${aws_iam_role.api_service_role.arn}"
  uri                     = "arn:aws:apigateway:${var.region}:sqs:path/${var.sqs_arn}"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}
resource "aws_iam_role" "api_service_role" {
      name = "api-service-role"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = ""
            Principal = {
              Service = "apigateway.amazonaws.com"
            }
          }
        ]
      })

    managed_policy_arns = [aws_iam_policy.api_service_role_policy.arn]

  depends_on {
    aws_iam_policy.api_service_role_policy
  }
} 

resource "aws_iam_policy" "api_service_role_policy" {
  name = "lambda_api_to_sqs_service_role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
{
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "sqs:GetQueueUrl",
          "sqs:ChangeMessageVisibility",
          "sqs:ListDeadLetterSourceQueues",
          "sqs:SendMessageBatch",
          "sqs:PurgeQueue",
          "sqs:ReceiveMessage",
          "sqs:SendMessage",
          "sqs:GetQueueAttributes",
          "sqs:CreateQueue",
          "sqs:ListQueueTags",
          "sqs:ChangeMessageVisibilityBatch",
          "sqs:SetQueueAttributes"
        ],
        "Resource": "${var.sqs_arn}"
      },
      {
        "Effect": "Allow",
        "Action": "sqs:ListQueues",
        "Resource": "*"
      }      
    ]
  })
}