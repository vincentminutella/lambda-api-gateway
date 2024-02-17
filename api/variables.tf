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
