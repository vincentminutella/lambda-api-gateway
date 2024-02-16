variable "domain_name_arn" {
    type = string 
    description = "domain of the api gateway"
}

variable "sqs_arn" {
    type = string
    description = "arn of target queue"
}

variable "region" {
    type = string
    description = "the region of deployment"
}