variable "domain_name_arn" {
    type = string
    description = "the associated api domain name"
    default = ""
}

variable "sqs_arn" {
    type = string
    description = "the receiving queue's arn"
    default = module.sqs.sqs_arn
}

variable "table_arn" {
    type = string
    decription = "arn of the todo list table"
    default = module.dynamodb.table_arn
}

variable "region" {
    type = string
    description = "the deployment region"
    default = "us-west-1"
}
