provider "aws" {
    region = var.region
}

module "api_gateway" {
    source = ".//api"
    region = var.region
    sqs_arn = module.sqs.sqs_arn
    sqs_name = module.sqs.sqs_name    
}

module "sqs" {
    source = ".//sqs"
}

module "lambda" {
    source = ".//lambda"
    sqs_arn = module.sqs.sqs_arn
    table_arn = module.dynamodb.table_arn
}

module "dynamodb" {
    source = ".//dynamodb"
}
