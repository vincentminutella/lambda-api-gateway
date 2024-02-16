variable "sqs_arn" {
    type = string
    description = "arn of the trigger queue"
}

variable "table_arn" {
    type = string
    description = "arn of the receiving table"
}