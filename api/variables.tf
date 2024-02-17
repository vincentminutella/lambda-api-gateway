variable "domain_name" {
    type = string 
    description = "domain of the api gateway"
    default = "brosona-api-test.net"
}

variable "cert" {
    type = string
    description = "arn of domain cert"
    default = "arn:aws:acm:us-west-1:730335346805:certificate/f18fdec0-3247-4ccc-8285-0d196c9a6a59"
}

variable "sqs_arn" {
    type = string
    description = "arn of target queue"
}

variable "sqs_name" {
    type = string
    description = "name of target queue"
}

variable "region" {
    type = string
    description = "the region of deployment"
}

variable "stage_name" {
    type = string
    description = "default stage of the api deployment"
    default = "main"
}