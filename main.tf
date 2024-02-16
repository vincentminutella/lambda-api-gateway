provider "aws" {
    region = "us-west-1"
}

module "api_gateway" {
    source = ".//api"
    domain_name_arn = var.domain_name_arn
    region = var.region
    sqs_arn = var.sqs_arn
}

module "sqs" {
    source = ".//sqs"
    sqs_arn = var.sqs_arn
}

module "lambda" {
    source = ".//lambda"
    sqs_arn = var.sqs_arn
    table_arn = var.table_arn
}

module "dynamodb" {
    source = ".//dynamodb"
}
