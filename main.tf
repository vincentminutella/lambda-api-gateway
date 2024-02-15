provider "aws" {
    region = "us-west-1"
}

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "http-api"
  description   = "HTTP API Gateway, Lambda, DynamoDb"
  protocol_type = "HTTP"

  domain_name = var.domain_name_arn
  

  integrations = {
    "POST /items" = {
      lambda_arn             =  module.lambda.lambda_arn
    }

    "GET /items" = {
      lambda_arn             = module.lambda.lambda_arn
    }

    "GET /items/{id}" = {
      lambda_arn             = module.lambda.lambda_arn
    }

    "PUT /items/{id}" = {
      lambda_arn             = module.lambda.lambda_arn
    }

    "DELETE /items/{id}" = {
      lambda_arn             = module.lambda.lambda_arn
    }

    "$default" = {
      lambda_arn             = module.lambda.lambda_arn 
    }
  }
}

module "lambda" {
    source = ".//lambda"
}

module "dynamodb" {
    source = ".//dynamodb"
}
